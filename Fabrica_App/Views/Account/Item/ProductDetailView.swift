import SwiftUI

struct ProductDetailView: View {
    var itemID: String

    // Use the shared CartManager to persist locally
    @ObservedObject private var cart = CartManager.shared
    @State private var showAddedAlert = false

    // Find the item based on its ID
    var item: Item? {
        return items.first(where: { $0.id == itemID })
    }

    var body: some View {
        VStack(alignment: .leading) {
            if let item = item {
                // Product Image
                Group {
                    if UIImage(named: item.imageName) != nil {
                        Image(item.imageName)
                            .resizable()
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .foregroundColor(.gray)
                    }
                }
                .scaledToFit()
                .frame(width: 200, height: 200)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .frame(maxWidth: .infinity, alignment: .center)

                // Product Name
                Text(item.name)
                    .font(.title)
                    .bold()
                    .padding(.top)

                // Rating (star) — placeholder rating for now
                HStack {
                    Text("4.5 ⭐")
                    Spacer()
                }
                .padding(.top, 5)

                // Price and Discount — currently no discount information in Item, so show price
                HStack {
                    Text("₱\(Int(item.price))")
                        .foregroundColor(.red)
                        .font(.title2)
                        .bold()
                }
                .padding(.top)
                .frame(maxWidth: .infinity, alignment: .leading)

                // Description Section (use Item properties)
                VStack(alignment: .leading) {
                    Text("Description:")
                        .font(.headline)
                        .padding(.top)
                    Text("Type: \(item.type)")
                    Text("Size: \(item.size)")
                    Text("Color: \(item.color)")
                    Text("Category: \(item.category)")
                }
                .padding(.horizontal)

                // Add to Cart and Buy Now buttons
                HStack {
                    Button(action: {
                        // Add to cart using local persistence (CartManager)
                        cart.add(productId: item.id,
                                 name: item.name,
                                 price: item.price,
                                 imageURL: item.imageName,
                                 discount: nil,
                                 quantity: 1)
                        // show confirmation
                        showAddedAlert = true
                    }) {
                        Text("Add to Cart")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    Button(action: {
                        // Action for buy now (left as-is)
                    }) {
                        Text("Buy Now")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
            } else {
                // If item is not found
                Text("Product not found")
                    .font(.title)
                    .foregroundColor(.red)
            }

            Spacer()
        }
        .navigationBarTitle("Product Details", displayMode: .inline)
        .padding()
        .alert(isPresented: $showAddedAlert) {
            Alert(title: Text("Added to Cart"),
                  message: Text("\(item?.name ?? "Item") has been added to your cart."),
                  dismissButton: .default(Text("OK")))
        }
    }
}

struct ProductDetailView_Preview: PreviewProvider {
    static var previews: some View {
        ProductDetailView(itemID: "SHO-001")
    }
}
