//
//  CategoryView.swift
//  Fabrica_App
//
//  Created by STUDENT on 11/19/25.
//

import SwiftUI

// CategoryView: shows the selected category as a top "pill" and a 2-column product grid.
// Uses the existing `Item` type and the global `items` array defined in:
// Fabrica_App/Views/Account/Item/Items.swift
// Tapping a product navigates to ProductDetailView(itemID:).

struct CategoryView: View {
    let selectedCategory: String

    // Use the global `items` array from Items.swift
    // Items.swift defines `let items: [Item]` and Item has an `id: String` property.
    private var filteredItems: [Item] {
        // show all when category is "All" or empty
        guard !selectedCategory.trimmingCharacters(in: .whitespaces).isEmpty,
              selectedCategory.lowercased() != "all" else {
            return items
        }
        return items.filter { $0.category.lowercased() == selectedCategory.lowercased() }
    }

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        VStack {
            // Top pill-style category title
            Text(selectedCategory)
                .font(.system(size: 18, weight: .semibold))
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.primary, lineWidth: 1)
                )
                .padding(.top, 12)

            // Optional filter / sort controls could go here

            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(filteredItems, id: \.id) { item in
                        NavigationLink(destination: ProductDetailView(itemID: item.id)) {
                            VStack(alignment: .leading, spacing: 8) {
                                // product image placeholder / real image if available
                                Group {
                                    if UIImage(named: item.imageName) != nil {
                                        Image(item.imageName)
                                            .resizable()
                                            .scaledToFill()
                                    } else {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.15))
                                    }
                                }
                                .frame(height: 80)
                                .cornerRadius(6)
                                .clipped()

                                Text(item.name)
                                    .font(.subheadline)
                                    .lineLimit(2)

                                Text("₱\(Int(item.price))")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.35), lineWidth: 1)
                            )
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.top, 20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Preview using existing global `items` (falls back if not available)
#if DEBUG
struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CategoryView(selectedCategory: "Shoes")
        }
    }
}
#endif
