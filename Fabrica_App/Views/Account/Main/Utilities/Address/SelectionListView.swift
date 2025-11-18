//
//  SelectionListView.swift
//  Fabrica_App
//
//  Created by STUDENT on 11/18/25.
//

import SwiftUI

/// Generic searchable selection list for items that are Identifiable & have a `name` property.
/// For simplicity we use key paths to extract names.
struct SelectionListView<Item: Identifiable & Equatable>: View {
    let title: String
    let items: [Item]
    let selected: Item?
    let onSelect: (Item) -> Void

    @Environment(\.presentationMode) var presentationMode
    @State private var query: String = ""

    // A helper to derive a display name via Mirror (assumes property "name" exists)
    private func displayName(of item: Item) -> String {
        let mirror = Mirror(reflecting: item)
        if let pair = mirror.children.first(where: { $0.label == "name" }),
           let name = pair.value as? String {
            return name
        }
        return String(describing: item)
    }

    var filtered: [Item] {
        if query.isEmpty { return items }
        return items.filter {
            displayName(of: $0).localizedCaseInsensitiveContains(query)
        }
    }

    var body: some View {
        NavigationView {
            List {
                if filtered.isEmpty {
                    Text("No results")
                        .foregroundColor(.gray)
                } else {
                    ForEach(filtered, id: \.id) { item in
                        Button(action: {
                            onSelect(item)
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                Text(displayName(of: item))
                                    .foregroundColor(.black)
                                Spacer()
                                if let selected = selected, selected == item {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.black)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.black)
                }
            }
            .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always))
        }
    }
}
