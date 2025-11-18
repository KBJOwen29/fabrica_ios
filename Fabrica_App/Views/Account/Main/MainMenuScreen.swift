import SwiftUI

// Model for limited offers (now using the updated Item structure)
struct OfferItemModel {
    let imageName: String
    let title: String
    let originalPrice: String
    let discount: String? // Optional discount for limited offers
    let price: String // Price (this can be discounted price or regular price)
    let id: String // Now including the item ID
}

struct MainMenuScreen: View {
    // Randomize function to get random items and random discount for "Limited Offers"
    func getRandomOffers(items: [Item], count: Int, hasDiscount: Bool) -> [OfferItemModel] {
        let randomItems = items.shuffled().prefix(count)
        return randomItems.map { item in
                // For "For You" section, no discount, just show regular price
                return OfferItemModel(
                    imageName: item.imageName,
                    title: item.name,
                    originalPrice: "₱\(Int(item.price))", // Regular price
                    discount: nil, // No discount
                    price: "₱\(Int(item.price))", // Regular price
                    id: item.id
                )
        }
    }


    // Get random items for the "For You" section (randomize 4 items without discount)
    var forYouItems: [OfferItemModel] {
        return getRandomOffers(items: items, count: 6, hasDiscount: false)
    }

    var body: some View {
        NavigationView { // Wrap in a NavigationView for navigation links
            ZStack {
                ScrollView { // Scrollable content section
                    VStack(spacing: 20) {
                        // Search Bar Section (Moved to the top)
                        HStack {
                            TextField("Search", text: .constant("")) // Bind the search text if needed
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                                .padding(.top, 40)
                                .padding(.horizontal)
                        }

                        // Categories Section
                        Text("Categories")
                            .font(.headline)
                            .padding(.leading) // Align the title to the left
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                NavigationLink(destination: Text("Men Category")) {
                                    CategoryItem(name: "Men", imageName: "Men") // Change to your image name
                                }
                                NavigationLink(destination: Text("Women Category")) {
                                    CategoryItem(name: "Women", imageName: "women") // Change to your image name
                                }
                                NavigationLink(destination: Text("Shoes Category")) {
                                    CategoryItem(name: "Shoes", imageName: "shoes") // Change to your image name
                                }
                                NavigationLink(destination: Text("Caps Category")) {
                                    CategoryItem(name: "Caps", imageName: "caps") // Change to your image name
                                }
                            }
                            .padding(.horizontal)
                        }
                        

                        // "For You" Section
                        Text("For You")
                            .font(.headline)
                            .padding(.leading) // Align the title to the left
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()), // This will create 2 flexible columns
                            GridItem(.flexible())
                        ], spacing: 20) {
                            ForEach(forYouItems, id: \.id) { offer in
                                NavigationLink(destination: ProductDetailView(itemID: offer.id)) {
                                    OfferItem(offer: offer)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                    .padding(.bottom, 100) // Space for the fixed bottom tab
                }

                // Fixed Bottom Navigation Bar with 4 icons (No search icon here anymore)
                VStack {
                    Spacer()
                    HStack {
                        Button(action: {
                            // Empty action for the Home button (won't navigate anywhere)
                        }) {
                            Image(systemName: "house.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.black) // Black icon color
                                .frame(maxWidth: .infinity) // Distribute space equally
                                .padding(.vertical, 10)
                        }
                        NavigationLink(destination: CartMenuScreen().navigationBarBackButtonHidden(true)) {
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
            .navigationBarHidden(true)
        }
    }
}

// MARK: - CategoryItem (unchanged)
struct CategoryItem: View {
    let name: String
    let imageName: String
    
    var body: some View {
        VStack {
            Image(imageName) // Load image from assets
                .resizable()
                .frame(width: 50, height: 50)
                .scaledToFit()
            
            Text(name)
                .font(.caption)
                .foregroundColor(.black)
        }
        .frame(width: 70)
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
    }
}

// MARK: - OfferItem (visual only, no navigation logic here)
struct OfferItem: View {
    let offer: OfferItemModel
    
    var body: some View {
        VStack(alignment: .leading) {
            // Image centered at the top
            Image(offer.imageName) // Load image from assets
                .resizable()
                .scaledToFit() // Ensures the aspect ratio is maintained
                .frame(width: 90, height: 90) // Make the image smaller
                .padding(.top, 10) // Padding to keep the image from sticking to the top edge
                .frame(maxWidth: .infinity) // Center image horizontally

            VStack(alignment: .leading) {
                Text(offer.title)
                    .bold()
                    .lineLimit(1)
                    .foregroundColor(.black)
                
                if let discount = offer.discount {
                    Text(discount)
                        .font(.caption)
                        .foregroundColor(.red)
                }
                
                if offer.discount != nil {
                    Text(offer.originalPrice) // Original price with strikethrough
                        .strikethrough()
                        .foregroundColor(.gray)
                        .font(.caption)
                }
                
                Text(offer.price) // Price (discounted or regular)
                    .bold()
                    .font(.title2)
                    .foregroundColor(.black)
            }
            .padding(.top, 5)
            .padding(.horizontal)
            
            Spacer()
        }
        .frame(width: 150, height: 230) // Adjust size for each offer item
        .padding(5)
        .background(RoundedRectangle(cornerRadius: 15).stroke(Color.gray, lineWidth: 1))
    }
}

struct MainMenuScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuScreen()
    }
}
