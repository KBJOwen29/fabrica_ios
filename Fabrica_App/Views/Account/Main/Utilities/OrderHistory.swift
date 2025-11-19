//
//  OrderHistory.swift
//  Fabrica_App
//
//  Created by STUDENT on 11/18/25.
//  Updated: Added delete (swipe + batch), filtering, multi-select.
//

import SwiftUI

enum OrderFilter: String, CaseIterable {
    case all = "All"
    case rated = "Rated"
    case unrated = "Unrated"
}

struct OrderHistory: View {
    @ObservedObject private var orderStore = OrderStore.shared
    @ObservedObject private var auth = AuthService.shared

    @State private var filter: OrderFilter = .all
    @State private var editMode: EditMode = .inactive
    @State private var selectedForBatchDelete: Set<String> = []
    @State private var showBatchDeleteAlert = false

    private var currentEmail: String? {
        auth.currentUser?.getEmail()
    }

    private var filteredOrders: [Order] {
        guard let email = currentEmail else { return [] }
        let all = orderStore.orders(for: email)
        switch filter {
        case .all: return all
        case .rated: return all.filter { $0.rating != nil }
        case .unrated: return all.filter { $0.rating == nil }
        }
    }

    var body: some View {
        VStack {
            header

            if currentEmail == nil {
                emptyState(text: "Please sign in to view your order history.")
            } else if filteredOrders.isEmpty {
                emptyState(text: "No orders found.")
            } else {
                List(selection: $selectedForBatchDelete) {
                    ForEach(filteredOrders) { order in
                        orderRow(order)
                            .contentShape(Rectangle())
                    }
                    .onDelete(perform: handleSwipeDelete)
                }
                .environment(\.editMode, $editMode)
            }

            footerBar
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Order History")
        .alert(isPresented: $showBatchDeleteAlert) {
            Alert(
                title: Text("Delete Orders"),
                message: Text("Delete the selected orders? This cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    performBatchDelete()
                },
                secondaryButton: .cancel()
            )
        }
    }

    // MARK: - Subviews

    private var header: some View {
        VStack(spacing: 8) {
            Picker("Filter", selection: $filter) {
                ForEach(OrderFilter.allCases, id: \.self) { f in
                    Text(f.rawValue).tag(f)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)

            HStack {
                if editMode == .inactive {
                    Button {
                        withAnimation { editMode = .active }
                    } label: {
                        Text("Select Multiple")
                            .font(.footnote)
                            .padding(6)
                            .background(Color.blue.opacity(0.15))
                            .cornerRadius(6)
                    }
                } else {
                    Button {
                        withAnimation {
                            editMode = .inactive
                            selectedForBatchDelete.removeAll()
                        }
                    } label: {
                        Text("Cancel Selection")
                            .font(.footnote)
                            .padding(6)
                            .background(Color.red.opacity(0.15))
                            .cornerRadius(6)
                    }

                    Button {
                        if !selectedForBatchDelete.isEmpty {
                            showBatchDeleteAlert = true
                        }
                    } label: {
                        Text("Delete (\(selectedForBatchDelete.count))")
                            .font(.footnote)
                            .padding(6)
                            .background(selectedForBatchDelete.isEmpty ? Color.gray.opacity(0.15) : Color.red.opacity(0.3))
                            .cornerRadius(6)
                    }
                    .disabled(selectedForBatchDelete.isEmpty)
                }

                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .padding(.top, 8)
    }

    private func emptyState(text: String) -> some View {
        VStack(spacing: 12) {
            Text(text)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var footerBar: some View {
        HStack {
            Spacer()
            Text("\(filteredOrders.count) order(s)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
    }

    private func orderRow(_ order: Order) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(order.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                Spacer()
                Text("x\(order.quantity)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            HStack(spacing: 6) {
                Text(priceString(order.price * Double(order.quantity)))
                    .font(.subheadline)
                    .fontWeight(.bold)

                if let rating = order.rating {
                    Text("Rated \(rating)/5")
                        .font(.caption)
                        .foregroundColor(.green)
                } else {
                    Text("Not rated")
                        .font(.caption2)
                        .foregroundColor(.orange)
                }
                Spacer()
            }

            Text("Purchased: \(formatted(date: order.purchasedAt))")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 6)
    }

    // MARK: - Swipe Delete
    private func handleSwipeDelete(at offsets: IndexSet) {
        guard let email = currentEmail else { return }
        let idsToDelete = offsets.map { filteredOrders[$0].id }
        OrderStore.shared.deleteOrders(for: email, ids: idsToDelete)
    }

    // MARK: - Batch Delete
    private func performBatchDelete() {
        guard let email = currentEmail else { return }
        OrderStore.shared.deleteOrders(for: email, ids: Array(selectedForBatchDelete))
        selectedForBatchDelete.removeAll()
        editMode = .inactive
    }

    // MARK: - Helpers
    private func priceString(_ value: Double) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.locale = Locale.current
        return f.string(from: NSNumber(value: value)) ?? "\(value)"
    }

    private func formatted(date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "MMM d, yyyy h:mm a"
        return df.string(from: date)
    }
}

struct OrderHistory_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OrderHistory()
        }
    }
}
