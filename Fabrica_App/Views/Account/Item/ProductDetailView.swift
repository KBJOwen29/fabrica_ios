import SwiftUI

struct ProductDetailView: View {
    var itemID: String
    
    // Find the item based on its ID
    var item: Item? {
        return items.first(where: { $0.id == itemID })
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if let _ = item {
                // Product Image
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity, alignment: .center) // This centers the image horizontally
                
                // Product Name
                Text("Product Name Placeholder")
                    .font(.title)
                    .bold()
                    .padding(.top)
                    .frame(maxWidth: .infinity, alignment: .leading) // Ensure left alignment
                
                // Rating (star)
                HStack {
                    Text("4.5 ⭐")
                    Spacer()
                }
                .padding(.top, 5)
                .frame(maxWidth: .infinity, alignment: .leading) // Ensure left alignment
                
                // Price and Discount
                HStack {
                    Text("₱0.00")
                        .strikethrough()
                        .foregroundColor(.gray)
                        .font(.body)
                    
                    Text("₱0.00") // Discounted price
                        .foregroundColor(.red)
                        .font(.title2)
                        .bold()
                }
                .padding(.top)
                .frame(maxWidth: .infinity, alignment: .leading) // Ensure left alignment
                
                // Description Section
                VStack(alignment: .leading) {
                    Text("Description:")
                        .font(.headline)
                        .padding(.top)
                    Text("Type: Placeholder")
                    Text("Size: Placeholder")
                }
                .padding(.horizontal)
                
                // Add to Cart and Buy Now buttons
                HStack {
                    Button(action: {
                        // Action for adding to cart
                    }) {
                        Text("Add to Cart")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        // Action for buy now
                    }) {
                        Text("Buy Now")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
            } else {
                // If item is not found
                Text("Product not found")
                    .font(.title)
                    .foregroundColor(.red)
            }
        }
        .navigationBarTitle("Product Details", displayMode: .inline)
        .padding()
    }
}

struct ProductDetailView_Preview: PreviewProvider {
    static var previews: some View {
        // Show the layout with empty placeholders (use any sample itemID for preview)
        ProductDetailView(itemID: "SHO-001")
    }
}
