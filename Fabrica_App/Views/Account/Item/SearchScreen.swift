////
////  SearchScreen.swift
////  Fabrica_App
////
////  Created by STUDENT on 11/19/25.
////
//
//import SwiftUI
//
//struct SearchScreen: View {
//    @State private var query: String = ""
//    
//    private var filtered: [Item] {
//        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
//        guard !trimmed.isEmpty else { return items }
//        return items.filter {
//            let q = trimmed.lowercased()
//            return $0.name.lowercased().contains(q)
//                || $0.category.lowercased().contains(q)
//                || $0.color.lowercased().contains(q)
//                || $0.size.lowercased().contains(q)
//                || $0.type.lowercased().contains(q)
//        }
//    }
//    
//    private let columns = [
//        GridItem(.flexible(), spacing: 16),
//        GridItem(.flexible(), spacing: 16)
//    ]
//    
//    var body: some View {
//        VStack(spacing: 0) {
//            HStack {
//                Image(systemName: "magnifyingglass")
//                    .foregroundColor(.gray)
//                TextField("Search products, categories...", text: $query)
//                    .textInputAutocapitalization(.never)
//                    .disableAutocorrection(true)
//                if !query.isEmpty {
//                    Button { query = "" } label: {
//                        Image(systemName: "xmark.circle.fill")
//                            .foregroundColor(.gray)
//                    }
//                }
//            }
//            .padding(12)
//            .background(
//                RoundedRectangle(cornerRadius: 12)
//                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
//            )
//            .padding(.horizontal, 14)
//            .padding(.top, 14)
//            
//            if filtered.isEmpty {
//                Spacer()
//                Text("No results")
//                    .foregroundColor(.secondary)
//                Spacer()
//            } else {
//                ScrollView {
//                    LazyVGrid(columns: columns, spacing: 20) {
//                        ForEach(filtered, id: \.id) { item in
//                            NavigationLink(destination: ProductDetailView(itemID: item.id)) {
//                                VStack(alignment: .leading, spacing: 8) {
//                                    Group {
//                                        if UIImage(named: item.imageName) != nil {
//                                            Image(item.imageName)
//                                                .resizable()
//                                                .scaledToFit()
//                                                .frame(maxWidth: .infinity)
//                                                .frame(height: 120)
//                                                .background(Color.gray.opacity(0.12))
//                                                .cornerRadius(10)
//                                        } else {
//                                            Rectangle()
//                                                .fill(Color.gray.opacity(0.15))
//                                                .frame(height: 120)
//                                                .cornerRadius(10)
//                                        }
//                                    }
//                                    
//                                    Text(item.name)
//                                        .font(.subheadline)
//                                        .lineLimit(2)
//                                    
//                                    Text("₱\(Int(item.price))")
//                                        .font(.caption)
//                                        .foregroundColor(.secondary)
//                                }
//                                .padding(12)
//                                .background(
//                                    RoundedRectangle(cornerRadius: 12)
//                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
//                                )
//                            }
//                        }
//                    }
//                    .padding(.horizontal, 14)
//                    .padding(.top, 20)
//                    .padding(.bottom, 20)
//                }
//            }
//        }
//        .navigationTitle("Search")
//        .navigationBarTitleDisplayMode(.inline)
//    }
//}
