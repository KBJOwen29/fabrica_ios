import SwiftUI

struct ProductDetailView: View {
    var itemID: String
    
    // Find the item based on its ID
    var item: Item? {
        return items.first(where: { $0.id == itemID })
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if let item = item {
                // Product Image
                // Try to load named asset, fallback to system photo icon if missing
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
                .frame(maxWidth: .infinity, alignment: .center) // This centers the image horizontally
                
                // Product Name
                Text(item.name)
                    .font(.title)
                    .bold()
                    .padding(.top)
                    .frame(maxWidth: .infinity, alignment: .leading) // Ensure left alignment
                
                // Rating (star) — placeholder rating for now
                HStack {
                    Text("4.5 ⭐")
                    Spacer()
                }
                .padding(.top, 5)
                
                // Price and Discount — currently no discount information in Item, so show price
                HStack {
                    // Only show original price if you have discount info. For now show main price.
                    Text("₱\(Int(item.price))")
                        .foregroundColor(.red)
                        .font(.title2)
                        .bold()
                }
                .padding(.top)
                .frame(maxWidth: .infinity, alignment: .leading) // Ensure left alignment
                
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
                        // Action for adding to cart
                    }) {
                        Text("Add to Cart")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
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
    }
}

struct ProductDetailView_Preview: PreviewProvider {
    static var previews: some View {
        // Show the layout with a sample itemID for preview
        ProductDetailView(itemID: "SHO-001")
    }
}
