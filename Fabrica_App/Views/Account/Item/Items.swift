import Foundation

// MARK: - Item Structure to Represent Each Product

// This structure holds all the information about each item.
struct Item {
    var id: String // Unique identifier for each item
    var name: String
    var price: Double
    var category: String
    var color: String
    var size: String
    var type: String
    var imageName: String // Image name associated with the item
    
    // Initializer to create an item (ID can be manually assigned here)
    init(name: String, price: Double, category: String, color: String, size: String, type: String, imageName: String, id: String) {
        self.name = name
        self.price = price
        self.category = category
        self.color = color
        self.size = size
        self.type = type
        self.imageName = imageName
        self.id = id // You assign the ID manually
    }
}

// MARK: - List of Items

// This is the list of all items, where you assign the ID manually.
let items: [Item] = [
    Item(name: "Nike Pegasus 41", price: 7395, category: "Shoes", color: "Green", size: "41", type: "Shoes", imageName: "Green_Nike_Pegasus_41", id: "SHO-001"),
    Item(name: "Black T-Shirt", price: 1599, category: "Men", color: "Black", size: "L", type: "T-Shirt", imageName: "Black_Shirt", id: "MEN-001"),
    Item(name: "Green T-Shirt", price: 1549, category: "Men", color: "Green", size: "M", type: "T-Shirt", imageName: "Green_Shirt", id: "MEN-002"),
    Item(name: "LA Blue Cap", price: 2900, category: "Cap", color: "Blue", size: "M", type: "Cap", imageName: "LA_Blue_Cap", id: "CAP-001"),
    Item(name: "Black Cap", price: 1500, category: "Cap", color: "Black", size: "L", type: "Cap", imageName: "Black_Cap", id: "CAP-002"),
    Item(name: "Navy Blue Polo Shirt", price: 1800, category: "Men", color: "Navy Blue", size: "Large", type: "Polo_Shirt", imageName: "Navy_Blue_PoloShirt", id: "MEN-003")
]

// Now, each item has a manually assigned ID.
