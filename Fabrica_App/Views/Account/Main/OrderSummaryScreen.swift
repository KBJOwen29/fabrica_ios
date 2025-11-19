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

    private let providedItems: [CartProduct]
    private let shippingFee: Double = 50
    private let containerHPadding: CGFloat = 16

    // New: confirmation + programmatic nav to Order History
    @State private var showConfirmOrder = false
    @State private var goToOrderHistory = false

    init(items: [CartProduct] = []) {
        self.providedItems = items
    }

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

    var body: some View {
        VStack(spacing: 0) {
            // Header - small top padding only
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.primary)
                }
                Spacer()
                Text("Order Summary")
                    .font(.system(size: 22, weight: .bold))
                Spacer()
                Color.clear.frame(width: 22)
            }
            .padding(.horizontal, containerHPadding)
            .padding(.top, 12)

            // Address block
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "mappin.and.ellipse")
                    .font(.system(size: 28))
                    .frame(width: 36, height: 36)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Address")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text("Ibabang Dupay, Lucena, Quezon\nJim Owen K. Bognalbal\n0968 719 0116")
                        .font(.subheadline)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
                Button("Change") {
                    // TODO: Navigate to address selection
                }
                .font(.subheadline)
                .foregroundColor(.blue)
            }
            .padding(.horizontal, containerHPadding)
            .padding(.top, 8)

            // Main Scrollable content - this will expand vertically and keep content at the top
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if selectedItems.isEmpty {
                        // Empty/caution state
                        VStack(spacing: 12) {
                            Spacer(minLength: 6)
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.orange)
                                .frame(maxWidth: .infinity, alignment: .center)
                            Text("No items to summarize")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .center)
                            Text("Your cart is empty or nothing is selected. Add items to your cart to proceed.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            Spacer(minLength: 6)
                        }
                        .padding(.top, 18)
                    } else {
                        ForEach(selectedItems) { item in
                            OrderSummaryItemRow(
                                product: item,
                                onUpdateQty: { qty in
                                    cart.updateQuantity(id: item.id, quantity: qty)
                                }
                            )
                            Divider()
                        }

                        // Delivery ETA
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Get by (Month - Day - Year)")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text(formattedETA)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 8)

                        // Price summary
                        VStack(spacing: 10) {
                            summaryRow(label: "Product Price", value: productPrice)
                            summaryRow(label: "Shipping", value: shippingFee)
                            summaryRow(label: "Product Discount", value: -discountAmount)
                            Divider()
                            summaryRow(label: "Total", value: total, bold: true)
                        }
                        .padding(.top, 8)
                    }
                }
                .padding(.horizontal, containerHPadding)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            .frame(maxWidth: .infinity)
            .layoutPriority(1)

            // Programmatic navigation to Order History after placing the order
            NavigationLink(
                destination: OrderHistory().environmentObject(OrderStore.shared),
                isActive: $goToOrderHistory
            ) { EmptyView() }

            // Confirm button (fixed below the scrollable content)
            confirmButton(disabled: selectedItems.isEmpty)
                .padding(.horizontal, containerHPadding)
                .padding(.vertical, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemBackground).ignoresSafeArea())
        .navigationBarHidden(true)
        // Confirmation alert
        .alert(isPresented: $showConfirmOrder) {
            Alert(
                title: Text("Confirm Order"),
                message: Text("Place this order totaling \(priceString(total))?"),
                primaryButton: .default(Text("Place Order"), action: {
                    // Transfer items to Order History for current user
                    OrderStore.shared.addOrdersForCurrentUser(from: selectedItems)

                    // Remove ordered items from cart
                    selectedItems.forEach { cart.delete(id: $0.id) }

                    // Navigate to Order History
                    goToOrderHistory = true
                }),
                secondaryButton: .cancel()
            )
        }
    }

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

    private func confirmButton(disabled: Bool = false) -> some View {
        Button(action: {
            // Show confirmation alert before finalizing
            showConfirmOrder = true
        }) {
            Text("Confirm")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 56)
                .background(
                    RoundedRectangle(cornerRadius: 28)
                        .fill(disabled ? Color.gray : Color.black)
                        .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 4)
                )
        }
        .disabled(disabled)
    }

    private func priceString(_ value: Double) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.locale = Locale.current
        return f.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}

private struct OrderSummaryItemRow: View {
    let product: CartProduct
    let onUpdateQty: (Int) -> Void
    @State private var qty: Int

    init(product: CartProduct, onUpdateQty: @escaping (Int) -> Void) {
        self.product = product
        self.onUpdateQty = onUpdateQty
        self._qty = State(initialValue: product.quantity)
    }

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            // Image area - fixed
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.6), lineWidth: 1)
                    .frame(width: 84, height: 84)

                if let img = product.imageURL, !img.isEmpty, UIImage(named: img) != nil {
                    Image(img)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 74, height: 74)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 74, height: 74)
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(product.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)

                HStack(spacing: 12) {
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
        .padding(.vertical, 8)
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
            OrderSummaryScreen()
        }
    }
}
