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

// CATEGORY SCREEN (altered to show full image)
struct CategoryScreen: View {
    let category: String
    
    // Filter items by category (case-insensitive)
    private var filteredItems: [Item] {
        items.filter { $0.category.lowercased() == category.lowercased() }
    }
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        VStack {
            // Top pill
            Text(category)
                .font(.system(size: 18, weight: .semibold))
                .padding(.vertical, 10)
                .padding(.horizontal, 24)
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color.primary, lineWidth: 1)
                )
                .padding(.top, 12)
            
            if filteredItems.isEmpty {
                Text("No items found in \(category)")
                    .foregroundColor(.secondary)
                    .padding(.top, 40)
                Spacer()
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(filteredItems, id: \.id) { item in
                            NavigationLink(destination: ProductDetailView(itemID: item.id)) {
                                VStack(alignment: .leading, spacing: 10) {
                                    // FULL IMAGE (no cropping, aspect fit)
                                    Group {
                                        if UIImage(named: item.imageName) != nil {
                                            Image(item.imageName)
                                                .resizable()
                                                .scaledToFit()      // show full image
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 140) // adjust height as desired
                                                .background(Color.gray.opacity(0.12))
                                                .cornerRadius(10)
                                        } else {
                                            Rectangle()
                                                .fill(Color.gray.opacity(0.15))
                                                .frame(height: 140)
                                                .cornerRadius(10)
                                        }
                                    }
                                    
                                    Text(item.name)
                                        .font(.subheadline)
                                        .lineLimit(2)
                                    
                                    Text("₱\(Int(item.price))")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.35), lineWidth: 1)
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.top, 22)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// DEDICATED SEARCH SCREEN
struct SearchScreen: View {
    @State private var query: String = ""
    
    // Live filtered items (matches on name, category, color, size, or type)
    private var filtered: [Item] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return items }
        return items.filter {
            let q = trimmed.lowercased()
            return $0.name.lowercased().contains(q)
                || $0.category.lowercased().contains(q)
                || $0.color.lowercased().contains(q)
                || $0.size.lowercased().contains(q)
                || $0.type.lowercased().contains(q)
        }
    }
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Search bar pinned at top
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search products, categories...", text: $query)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                if !query.isEmpty {
                    Button {
                        query = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
            )
            .padding(.horizontal, 14)
            .padding(.top, 14)
            
            if filtered.isEmpty {
                Spacer()
                Text("No results")
                    .foregroundColor(.secondary)
                Spacer()
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(filtered, id: \.id) { item in
                            NavigationLink(destination: ProductDetailView(itemID: item.id)) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Group {
                                        if UIImage(named: item.imageName) != nil {
                                            Image(item.imageName)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 120)
                                                .background(Color.gray.opacity(0.12))
                                                .cornerRadius(10)
                                        } else {
                                            Rectangle()
                                                .fill(Color.gray.opacity(0.15))
                                                .frame(height: 120)
                                                .cornerRadius(10)
                                        }
                                    }
                                    
                                    Text(item.name)
                                        .font(.subheadline)
                                        .lineLimit(2)
                                    
                                    Text("₱\(Int(item.price))")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MainMenuScreen: View {
    // Randomize function to get random items for "For You"
    func getRandomOffers(items: [Item], count: Int, hasDiscount: Bool) -> [OfferItemModel] {
        let randomItems = items.shuffled().prefix(count)
        return randomItems.map { item in
            OfferItemModel(
                imageName: item.imageName,
                title: item.name,
                originalPrice: "₱\(Int(item.price))",
                discount: nil,
                price: "₱\(Int(item.price))",
                id: item.id
            )
        }
    }
    
    var forYouItems: [OfferItemModel] {
        getRandomOffers(items: items, count: 6, hasDiscount: false)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(spacing: 20) {
                        // SEARCH BAR (converted into a NavigationLink to SearchScreen)
                        NavigationLink(destination: SearchScreen()) {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                Text("Search products, categories...")
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                        }
                        .padding(.top, 40)
                        .padding(.horizontal)
                        
                        // Categories
                        Text("Categories")
                            .font(.headline)
                            .padding(.leading)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                NavigationLink(destination: CategoryScreen(category: "Men")) {
                                    CategoryItem(name: "Men", imageName: "Men")
                                }
                                NavigationLink(destination: CategoryScreen(category: "Women")) {
                                    CategoryItem(name: "Women", imageName: "women")
                                }
                                NavigationLink(destination: CategoryScreen(category: "Shoes")) {
                                    CategoryItem(name: "Shoes", imageName: "shoes")
                                }
                                NavigationLink(destination: CategoryScreen(category: "Cap")) {
                                    CategoryItem(name: "Caps", imageName: "caps")
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // For You
                        Text("For You")
                            .font(.headline)
                            .padding(.leading)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
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
                    .padding(.bottom, 100)
                }
                
                // Bottom navigation bar
                VStack {
                    Spacer()
                    HStack {
                        Button(action: {}) {
                            Image(systemName: "house.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                        }
                        NavigationLink(destination: CartMenuScreen().navigationBarBackButtonHidden(true)) {
                            Image(systemName: "cart.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                        }
                        NavigationLink(destination: ProfileMenuScreen().navigationBarBackButtonHidden(true)) {
                            Image(systemName: "person.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                        }
                    }
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .cornerRadius(30)
                    .shadow(radius: 10)
                    .padding(.horizontal)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - CategoryItem (unchanged visual component)
struct CategoryItem: View {
    let name: String
    let imageName: String
    
    var body: some View {
        VStack {
            Image(imageName)
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

// MARK: - OfferItem (visual only)
struct OfferItem: View {
    let offer: OfferItemModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(offer.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 110, height: 110)
                .padding(.top, 8)
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            
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
                    Text(offer.originalPrice)
                        .strikethrough()
                        .foregroundColor(.gray)
                        .font(.caption)
                }
                
                Text(offer.price)
                    .bold()
                    .font(.title3)
                    .foregroundColor(.black)
            }
            .padding(.top, 4)
            .padding(.horizontal, 6)
            
            Spacer()
        }
        .frame(width: 160, height: 250)
        .padding(6)
        .background(RoundedRectangle(cornerRadius: 15).stroke(Color.gray.opacity(0.5), lineWidth: 1))
    }
}

struct MainMenuScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuScreen()
    }
}
