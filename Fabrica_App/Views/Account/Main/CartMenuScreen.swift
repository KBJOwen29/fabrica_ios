//
//  CartMenuScreen.swift
//  Fabrica_App
//
//  Updated to use CartManager-backed cart items
//

import SwiftUI

struct CartMenuScreen: View {
    @ObservedObject private var cart = CartManager.shared
    @State private var showConfirmAlert = false

    var body: some View {
        VStack(alignment: .leading) {
            // Search bar visual
            HStack {
                Image(systemName: "magnifyingglass")
                Text("Search")
                    .foregroundColor(.secondary)
                Spacer()
            }
            .padding(12)
            .background(RoundedRectangle(cornerRadius: 22).stroke(Color.gray.opacity(0.4), lineWidth: 1))
            .padding(.horizontal)

            Text("My Cart")
                .font(.headline)
                .padding(.horizontal)
                .padding(.top, 8)

            if cart.items.isEmpty {
                VStack {
                    Spacer()
                    Text("Your cart is empty")
                        .foregroundColor(.secondary)
                    Spacer()
                }
            } else {
                ScrollView {
                    VStack(spacing: 18) {
                        ForEach(cart.items) { item in
                            CartItemRow(
                                product: item,
                                onToggle: { cart.toggleSelected(id: item.id) },
                                onUpdateQty: { qty in cart.updateQuantity(id: item.id, quantity: qty) },
                                onDelete: { cart.delete(id: item.id) }
                            )
                        }
                    }
                    .padding(.top)
                }
            }

            Spacer()

            // Subtotal + Confirm
            VStack(spacing: 12) {
                HStack {
                    Text("Subtotal:")
                        .font(.headline)
                    Spacer()
                    Text(priceString(cart.subtotal))
                        .font(.headline)
                }
                .padding(.horizontal)

                Button(action: {
                    showConfirmAlert = true
                }) {
                    Text("Confirm")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 56)
                        .background(
                            RoundedRectangle(cornerRadius: 28)
                                .fill(Color.black)
                                .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 4)
                        )
                        .padding(.horizontal)
                }
                .alert(isPresented: $showConfirmAlert) {
                    Alert(title: Text("Confirm"), message: Text("Proceed to checkout with subtotal \(priceString(cart.subtotal))?"), primaryButton: .default(Text("Yes")), secondaryButton: .cancel())
                }
                .padding(.bottom, 30)
                
                VStack {
                    HStack {
                        NavigationLink(destination:  MainMenuScreen().navigationBarBackButtonHidden(true)) {
                                Image(systemName: "house.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.black) // Black icon color
                                    .frame(maxWidth: .infinity) // Distribute space equally
                                    .padding(.vertical, 10)
                        }
                        Button(action: {
                            // Empty action for the Home button (won't navigate anywhere)
                        }) {
                            Image(systemName: "cart.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.black) // Black icon color
                                .frame(maxWidth: .infinity) // Distribute space equally
                                .padding(.vertical, 10)
                        }
                        NavigationLink(destination:  ProfileMenuScreen().navigationBarBackButtonHidden(true)) {
                            Image(systemName: "person.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.black) // Black icon color
                                .frame(maxWidth: .infinity) // Distribute space equally
                                .padding(.vertical, 10)
                        }
                    }
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .cornerRadius(30) // Rounded edges for bottom tab
                    .shadow(radius: 10) // Add shadow for effect
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
            .background(Color(UIColor.systemBackground))
            
        }
        .navigationBarHidden(true)
        .padding(.bottom, 6)
    }

    private func priceString(_ value: Double) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.locale = Locale.current
        return f.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}

// A reusable row view for a cart item that calls back to the manager for changes
struct CartItemRow: View {
    let product: CartProduct
    let onToggle: () -> Void
    let onUpdateQty: (Int) -> Void
    let onDelete: () -> Void

    @State private var qty: Int

    init(product: CartProduct, onToggle: @escaping () -> Void, onUpdateQty: @escaping (Int) -> Void, onDelete: @escaping () -> Void) {
        self.product = product
        self.onToggle = onToggle
        self.onUpdateQty = onUpdateQty
        self.onDelete = onDelete
        self._qty = State(initialValue: product.quantity)
    }

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            // Checkbox
            Button(action: onToggle) {
                Image(systemName: product.selected ? "checkmark.square" : "square")
                    .font(.title2)
            }
            .buttonStyle(PlainButtonStyle())
            .frame(width: 30)

            // Product image with border
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
                    // If remote images used, swap for AsyncImage
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 74, height: 74)
                }
            }

            // Details
            VStack(alignment: .leading, spacing: 6) {
                Text(product.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)

                if let discount = product.discount, discount > 0 {
                    Text("\(Int(discount * 100))% Off")
                        .font(.caption)
                        .foregroundColor(.green)
                        .fontWeight(.bold)
                }

                HStack(spacing: 12) {
                    // Quantity picker
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

                    // Prices
                    if let d = product.discount, d > 0 {
                        Text(priceString(product.price))
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .strikethrough()
                        Text(priceString(product.effectivePrice))
                            .font(.subheadline)
                            .fontWeight(.bold)
                    } else {
                        Text(priceString(product.effectivePrice))
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }

                    Spacer()

                    // Trash
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .foregroundColor(.primary)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(.horizontal)
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
        // For preview create a temporary manager state if needed
        CartMenuScreen()
    }
}
