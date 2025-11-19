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

    // Adjust to your real repository name
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
            headerView   // Fixed at top
            Divider()    // Thin separator right below header (optional)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 14) {

                    // Address
                    addressView

                    // Wallet balance
                    walletBalanceRow

                    // Items
                    if selectedItems.isEmpty {
                        emptyItemsNotice
                    } else {
                        itemsList
                    }

                    // ETA
                    etaSection

                    // Totals
                    totalsSection

                    // Wallet warning
                    if walletBalance < total && !selectedItems.isEmpty {
                        walletWarning
                    }
                }
                .padding(.horizontal, horizontalPadding)
                // Keep vertical padding minimal so content hugs top under header
                .padding(.top, 10)
                .padding(.bottom, 8)
            }
        }
        // Confirm button inset at bottom WITHOUT adding extra white space
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
                // goToOrderHistory = true // Optional
            }
        } message: {
            Text("Payment successful. Your order has been placed.")
        }
        .alert("Not Signed In", isPresented: $showNotSignedIn) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please sign in to place an order.")
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
            // Balancer
            Color.clear.frame(width: 34, height: 34)
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.top, 4)   // Minimal top padding to hug safe area
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
                Text("Ibabang Dupay, Lucena, Quezon\nJim Owen K. Bognalbal\n0968 719 0116")
                    .font(.subheadline)
            }

            Spacer()

            Button("Change") {
                // TODO: Navigate to address selection
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
                            .fill(selectedItems.isEmpty ? Color.gray : Color.black)
                            .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 3)
                    )
            }
            .disabled(selectedItems.isEmpty)
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.top, 6)
        .padding(.bottom, 8) // sits just above home indicator
        .background(.ultraThinMaterial)
    }

    // MARK: - Confirm Logic
    private func handleConfirm() {
        guard let user = auth.currentUser else {
            showNotSignedIn = true
            return
        }

        let needed = total
        let balance = user.getWalletBalance()

        if balance >= needed {
            user.subtractFunds(amount: needed)
            repo.update(user)
            auth.updateCurrentUserIfSame(user)

            // Optional: record order
            // OrderStore.shared.addOrder(items: selectedItems, total: needed)

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
