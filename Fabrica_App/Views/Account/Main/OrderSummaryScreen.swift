//
//  OrderSummaryScreen.swift
//  Fabrica_App
//
//  Created by STUDENT on 11/18/25.
//

import SwiftUI

struct OrderSummaryScreen: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject private var cart = CartManager.shared
    @ObservedObject private var auth = AuthService.shared

    private let repo = AccountsRepository.shared

    private let providedItems: [CartProduct]
    private let shippingFee: Double = 50
    private let horizontalPadding: CGFloat = 16

    // Alerts / navigation
    @State private var showConfirmOrder = false
    @State private var goToOrderHistory = false
    @State private var showInsufficientFunds = false
    @State private var showOrderSuccess = false
    @State private var showNotSignedIn = false

    // Address selection
    @State private var showingAddressSheet = false
    @State private var activeAddress: AddressEntry? = AddressViewModel.currentSelectedAddress()

    init(items: [CartProduct] = []) {
        self.providedItems = items
    }

    // MARK: - Derived Data
    private var selectedItems: [CartProduct] {
        if !providedItems.isEmpty {
            return providedItems
        }
        return cart.items.filter { $0.selected }
    }

    private var productPrice: Double {
        selectedItems.reduce(0) { $0 + ($1.effectivePrice * Double($1.quantity)) }
    }

    private var discountAmount: Double {
        selectedItems.reduce(0) { sum, item in
            let perUnitDiscount = max(0, item.price - item.effectivePrice)
            return sum + perUnitDiscount * Double(item.quantity)
        }
    }

    private var total: Double {
        productPrice + (selectedItems.isEmpty ? 0 : shippingFee)
    }

    private var formattedETA: String {
        let calendar = Calendar.current
        let target = calendar.date(byAdding: .day, value: 5, to: Date()) ?? Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM - d - yyyy"
        return formatter.string(from: target)
    }

    private var walletBalance: Double {
        auth.currentUser?.getWalletBalance() ?? 0
    }

    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            headerView
            Divider()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 14) {
                    addressView
                    walletBalanceRow

                    if selectedItems.isEmpty {
                        emptyItemsNotice
                    } else {
                        itemsList
                    }

                    etaSection
                    totalsSection

                    if walletBalance < total && !selectedItems.isEmpty {
                        walletWarning
                    }
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.top, 10)
                .padding(.bottom, 8)
            }
        }
        .safeAreaInset(edge: .bottom) {
            confirmBar
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemBackground))
        .alert("Confirm Order", isPresented: $showConfirmOrder) {
            Button("Cancel", role: .cancel) {}
            Button("Confirm") { handleConfirm() }
        } message: {
            Text("Proceed with payment of \(priceString(total)) from your wallet?")
        }
        .alert("Insufficient Funds", isPresented: $showInsufficientFunds) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your wallet balance does not cover \(priceString(total)). Please cash in first.")
        }
        .alert("Order Placed", isPresented: $showOrderSuccess) {
            Button("OK", role: .cancel) {
                // Optionally navigate to history:
                // goToOrderHistory = true
            }
        } message: {
            Text("Payment successful. Your order has been placed.")
        }
        .alert("Not Signed In", isPresented: $showNotSignedIn) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please sign in to place an order.")
        }
        // Present AddressList as a sheet so it returns to this screen after selection
        .sheet(isPresented: $showingAddressSheet, onDismiss: {
            reloadAddress()
        }) {
            AddressList { chosen in
                activeAddress = chosen
            }
        }
        .onAppear(perform: reloadAddress)
        .onReceive(auth.$currentUser) { _ in
            reloadAddress()
        }

        NavigationLink(destination: OrderHistory(), isActive: $goToOrderHistory) {
            EmptyView()
        }
    }

    // MARK: - Subviews

    private var headerView: some View {
        HStack {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.primary)
                    .frame(width: 34, height: 34)
            }

            Spacer()

            Text("Order Summary")
                .font(.system(size: 22, weight: .bold))

            Spacer()
            Color.clear.frame(width: 34, height: 34)
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.top, 4)
        .padding(.bottom, 4)
        .background(Color(.systemBackground))
    }

    private var addressView: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "mappin.and.ellipse")
                .font(.system(size: 22))
                .frame(width: 30, height: 30)

            VStack(alignment: .leading, spacing: 4) {
                Text("Address")
                    .font(.subheadline)
                    .fontWeight(.semibold)

                if let addr = activeAddress {
                    Text(renderAddress(addr))
                        .font(.subheadline)
                } else {
                    Text("No address selected.\nTap Change to choose.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            Button("Change") {
                // Show AddressList in a sheet (does not reset navigation stack)
                showingAddressSheet = true
            }
            .font(.subheadline)
            .foregroundColor(.blue)
        }
    }

    private var walletBalanceRow: some View {
        HStack {
            Text("Wallet Balance:")
                .font(.subheadline)
                .fontWeight(.semibold)
            Spacer()
            Text(priceString(walletBalance))
                .font(.subheadline)
                .fontWeight(.bold)
        }
    }

    private var emptyItemsNotice: some View {
        VStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 34))
                .foregroundColor(.orange)
            Text("No items selected.")
                .font(.headline)
            Text("Go back and select items to proceed.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
    }

    private var itemsList: some View {
        VStack(spacing: 12) {
            ForEach(selectedItems) { item in
                OrderSummaryItemRow(product: item) { newQty in
                    cart.updateQuantity(id: item.id, quantity: newQty)
                }
            }
        }
    }

    private var etaSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Delivery ETA")
                .font(.subheadline)
                .fontWeight(.semibold)
            Text(formattedETA)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }

    private var totalsSection: some View {
        VStack(spacing: 8) {
            summaryRow(label: "Products", value: productPrice)
            if discountAmount > 0 {
                summaryRow(label: "Discounts", value: -discountAmount)
            }
            summaryRow(label: "Shipping", value: selectedItems.isEmpty ? 0 : shippingFee)
            Divider()
            summaryRow(label: "Total", value: total, bold: true)
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(14)
    }

    private var walletWarning: some View {
        HStack(spacing: 6) {
            Image(systemName: "exclamationmark.circle")
                .foregroundColor(.red)
            Text("Insufficient wallet balance for this order.")
                .font(.footnote)
                .foregroundColor(.red)
            Spacer()
        }
    }

    private var confirmBar: some View {
        HStack {
            Button {
                showConfirmOrder = true
            } label: {
                Text("Confirm")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 54)
                    .background(
                        RoundedRectangle(cornerRadius: 26)
                            .fill(selectedItems.isEmpty || activeAddress == nil ? Color.gray : Color.black)
                            .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 3)
                    )
            }
            .disabled(selectedItems.isEmpty || activeAddress == nil)
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.top, 6)
        .padding(.bottom, 8)
        .background(.ultraThinMaterial)
    }

    // MARK: - Confirm Logic
    private func handleConfirm() {
        guard let user = auth.currentUser else {
            showNotSignedIn = true
            return
        }

        // Require address selection
        guard activeAddress != nil else {
            // Prompt to choose an address if desired
            showingAddressSheet = true
            return
        }

        let needed = total
        let balance = user.getWalletBalance()

        if balance >= needed {
            user.subtractFunds(amount: needed)
            repo.update(user)
            auth.updateCurrentUserIfSame(user)

            // Persist purchased items to OrderStore (per signed-in account)
            OrderStore.shared.addOrdersForCurrentUser(from: selectedItems)

            // Clear purchased items from cart
            for item in selectedItems {
                cart.delete(id: item.id)
            }

            showOrderSuccess = true
        } else {
            showInsufficientFunds = true
        }
    }

    // MARK: - Helpers
    private func summaryRow(label: String, value: Double, bold: Bool = false) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .fontWeight(.semibold)
            Spacer()
            Text(priceString(value))
                .font(.subheadline)
                .fontWeight(bold ? .bold : .regular)
        }
    }

    private func priceString(_ value: Double) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.locale = Locale.current
        return f.string(from: NSNumber(value: value)) ?? "\(value)"
    }

    private func reloadAddress() {
        activeAddress = AddressViewModel.currentSelectedAddress()
    }

    private func renderAddress(_ entry: AddressEntry) -> String {
        var lines: [String] = []
        lines.append("\(entry.barangay), \(entry.city)")
        lines.append("\(entry.province), \(entry.region)")
        if let notes = entry.notes {
            lines.append(notes)
        }
        return lines.joined(separator: "\n")
    }
}

// MARK: - Item Row
private struct OrderSummaryItemRow: View {
    let product: CartProduct
    let onUpdateQty: (Int) -> Void
    @State private var qty: Int

    init(product: CartProduct, onUpdateQty: @escaping (Int) -> Void) {
        self.product = product
        self.onUpdateQty = onUpdateQty
        _qty = State(initialValue: product.quantity)
    }

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.6), lineWidth: 1)
                    .frame(width: 70, height: 70)

                if let img = product.imageURL, !img.isEmpty, UIImage(named: img) != nil {
                    Image(img)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 62, height: 62)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 62, height: 62)
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(product.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)

                HStack(spacing: 10) {
                    Picker("", selection: Binding(get: { qty }, set: { newQty in
                        qty = newQty
                        onUpdateQty(newQty)
                    })) {
                        ForEach(1..<11) { i in
                            Text("\(i)").tag(i)
                        }
                    }
                    .pickerStyle(.menu)

                    Spacer()

                    Text(priceString(product.effectivePrice * Double(qty)))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }
        }
        .padding(.vertical, 6)
    }

    private func priceString(_ value: Double) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.locale = Locale.current
        return f.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}

struct OrderSummaryScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OrderSummaryScreen(items: [])
        }
    }
}
