//
//  CartMenuScreen.swift
//  Fabrica_App
//
//  Created by STUDENT on 10/18/25.
//

import SwiftUI

struct CartMenuScreen: View {
    @ObservedObject private var cart = CartManager.shared

    @State private var showEmptyCartAlert = false
    @State private var showNoAddressAlert = false
    @State private var showAddressSheet = false
    @State private var goToOrderSummary = false
    @State private var selectedItemsForOrder: [CartProduct] = []

    private let containerHPadding: CGFloat = 16

    var body: some View {
        VStack(spacing: 0) {
            // Header / Search
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 22).stroke(Color.gray.opacity(0.4), lineWidth: 1))

                Text("My Cart")
                    .font(.headline)
                    .padding(.top, 4)
            }
            .padding(.horizontal, containerHPadding)
            .padding(.top, 12)

            // Content
            Group {
                if cart.items.isEmpty {
                    VStack {
                        Spacer(minLength: 28)
                        Text("Your cart is empty")
                            .foregroundColor(.secondary)
                        Spacer(minLength: 28)
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 18) {
                            ForEach(cart.items) { item in
                                CartItemRow(
                                    product: item,
                                    onToggle: { cart.toggleSelected(id: item.id) },
                                    onUpdateQty: { qty in cart.updateQuantity(id: item.id, quantity: qty) },
                                    onDelete: { cart.delete(id: item.id) }
                                )
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 8)
                    }
                }
            }
            .padding(.horizontal, containerHPadding)
            .frame(maxWidth: .infinity)

            // Footer: subtotal + confirm + bottom tab
            VStack(spacing: 12) {
                HStack {
                    Text("Subtotal:")
                        .font(.headline)
                    Spacer()
                    Text(priceString(cart.subtotal))
                        .font(.headline)
                }

                // NavigationLink trigger
                NavigationLink(
                    destination: OrderSummaryScreen(items: selectedItemsForOrder).navigationBarBackButtonHidden(true),
                    isActive: $goToOrderSummary
                ) {
                    EmptyView()
                }

                Button(action: {
                    // 1) Ensure items selected
                    let selected = cart.items.filter { $0.selected }
                    if selected.isEmpty {
                        showEmptyCartAlert = true
                        return
                    }

                    // 2) Ensure an address is registered for the account (or guest)
                    let owner = AddressViewModel.storageOwnerEmail()
                    let hasAnyAddress = !AddressViewModel.loadAddresses(for: owner).isEmpty
                    if !hasAnyAddress {
                        showNoAddressAlert = true
                        return
                    }

                    // 3) Proceed to order summary
                    selectedItemsForOrder = selected
                    goToOrderSummary = true
                }) {
                    Text("Confirm")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 56)
                        .background(
                            RoundedRectangle(cornerRadius: 28)
                                .fill(Color.black)
                                .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 4)
                        )
                }
            }
            .padding(.horizontal, containerHPadding)
            .padding(.vertical, 12)
            .alert(isPresented: $showEmptyCartAlert) {
                Alert(
                    title: Text("Cart Empty"),
                    message: Text("There is nothing in the cart. Add items to proceed."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .alert(isPresented: $showNoAddressAlert) {
                Alert(
                    title: Text("No Address Registered"),
                    message: Text("Please add an address before proceeding to checkout."),
                    primaryButton: .default(Text("Add Address")) {
                        showAddressSheet = true
                    },
                    secondaryButton: .cancel(Text("Later"))
                )
            }
            .sheet(isPresented: $showAddressSheet) {
                // Present as a sheet so the user stays in the current flow
                AddressList()
            }

            // Bottom navigation bar (fixed)
            HStack(spacing: 0) {
                NavigationLink(destination: MainMenuScreen().navigationBarBackButtonHidden(true)) {
                    VStack {
                        Image(systemName: "house.fill")
                            .font(.system(size: 22))
                        Text("Home")
                            .font(.caption2)
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }

                // Current Cart button: no-op (we're on cart)
                Button(action: { }) {
                    VStack {
                        Image(systemName: "cart.fill")
                            .font(.system(size: 22))
                        Text("Cart")
                            .font(.caption2)
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }

                NavigationLink(destination: ProfileMenuScreen().navigationBarBackButtonHidden(true)) {
                    VStack {
                        Image(systemName: "person.fill")
                            .font(.system(size: 22))
                        Text("Profile")
                            .font(.caption2)
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }
            }
            .background(Color(.systemGray6))
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func priceString(_ value: Double) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.locale = Locale.current
        return f.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}

// MARK: - CartItemRow
struct CartItemRow: View {
    let product: CartProduct
    let onToggle: () -> Void
    let onUpdateQty: (Int) -> Void
    let onDelete: () -> Void

    @State private var qty: Int
    @State private var showDeleteConfirmation: Bool = false

    init(product: CartProduct, onToggle: @escaping () -> Void, onUpdateQty: @escaping (Int) -> Void, onDelete: @escaping () -> Void) {
        self.product = product
        self.onToggle = onToggle
        self.onUpdateQty = onUpdateQty
        self.onDelete = onDelete
        self._qty = State(initialValue: product.quantity)
    }

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Button(action: onToggle) {
                Image(systemName: product.selected ? "checkmark.square" : "square")
                    .font(.system(size: 22))
            }

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

                HStack(spacing: 8) {
                    if let d = product.discount, d > 0 {
                        Text(priceString(product.price))
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .strikethrough()
                    }
                    Text(priceString(product.effectivePrice))
                        .font(.subheadline)
                        .fontWeight(.bold)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 8) {
                Picker("", selection: Binding(get: { qty }, set: { newQty in
                    qty = newQty
                    onUpdateQty(newQty)
                })) {
                    ForEach(1..<11) { i in
                        Text("\(i)").tag(i)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(width: 60)
                .padding(.horizontal, 6)
                .background(RoundedRectangle(cornerRadius: 6).stroke(Color.gray.opacity(0.3)))

                Button(action: { showDeleteConfirmation = true }) {
                    Image(systemName: "trash")
                        .foregroundColor(.primary)
                }
                .buttonStyle(PlainButtonStyle())
                .alert(isPresented: $showDeleteConfirmation) {
                    Alert(
                        title: Text("Remove Item"),
                        message: Text("Remove \(product.name) from cart?"),
                        primaryButton: .destructive(Text("Remove"), action: onDelete),
                        secondaryButton: .cancel()
                    )
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

struct CartMenuScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CartMenuScreen()
        }
    }
}
