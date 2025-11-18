//
//  OrderHistory.swift
//  Fabrica_App
//
//  Created by STUDENT on 11/18/25.
//

import SwiftUI

struct OrderHistory: View {
    @ObservedObject private var auth = AuthService.shared
    @EnvironmentObject var store: OrderStore

    @State private var showRatingSheet = false
    @State private var targetOrder: Order?
    @State private var tempRating: Int = 0

    private var orders: [Order] {
        store.currentOrders
    }

    var body: some View {
        List {
            Section {
                ForEach(orders) { order in
                    OrderRow(order: order,
                             showRate: order.rating == nil,
                             onRateTap: {
                                targetOrder = order
                                tempRating = 0
                                showRatingSheet = true
                             })
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Order History")
        .sheet(isPresented: $showRatingSheet) {
            NavigationView {
                VStack(spacing: 16) {
                    Text("Rate your order")
                        .font(.headline)
                    if let o = targetOrder {
                        Text(o.name)
                            .multilineTextAlignment(.center)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    StarRatingView(rating: $tempRating, interactive: true)
                        .padding(.top, 8)

                    Button {
                        guard let orderId = targetOrder?.id, tempRating > 0 else { return }
                        store.rateCurrentUser(orderId: orderId, rating: tempRating)
                        showRatingSheet = false
                    } label: {
                        Text("Submit")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(tempRating > 0 ? Color.black : Color.gray.opacity(0.5))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .disabled(tempRating == 0)

                    Spacer()
                }
                .padding()
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Close") { showRatingSheet = false }
                    }
                }
            }
        }
    }
}

private struct OrderRow: View {
    let order: Order
    let showRate: Bool
    var onRateTap: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Group {
                if let imageName = order.imageName, UIImage(named: imageName) != nil {
                    Image(imageName).resizable().scaledToFill()
                } else {
                    Image(systemName: "photo").resizable().scaledToFit().foregroundColor(.gray)
                }
            }
            .frame(width: 56, height: 56)
            .background(Color.gray.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 6) {
                Text(order.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                HStack(spacing: 10) {
                    QuantityBadge(quantity: order.quantity)
                    Text("₱\(Int(order.price))")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }

                if let rating = order.rating {
                    StarRatingView(rating: .constant(rating), interactive: false)
                } else if showRate {
                    Button("Rate") { onRateTap() }
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .buttonStyle(.plain)
                        .padding(.top, 4)
                }
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

private struct QuantityBadge: View {
    let quantity: Int
    var body: some View {
        HStack(spacing: 6) {
            Text("\(quantity)")
                .font(.footnote)
                .fontWeight(.bold)
        }
        .padding(.horizontal, 8).padding(.vertical, 4)
        .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.black, lineWidth: 1))
    }
}

struct OrderHistoryy_Previews: PreviewProvider {
    static var previews: some View {
        OrderHistory()
    }
}
