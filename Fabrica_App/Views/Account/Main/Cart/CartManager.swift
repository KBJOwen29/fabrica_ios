//
//  CartManager.swift
//  Fabrica_App
//
//  Created by STUDENT on 10/29/25.
//

import Foundation
import CoreData
import Combine
import SwiftUI

final class CartManager: ObservableObject {
    static let shared = CartManager()

    @Published private(set) var items: [CartProduct] = []

    private let context: NSManagedObjectContext

    private var cancellables = Set<AnyCancellable>()

    private init() {
        context = CartPersistence.shared.container.viewContext
        fetchItems()
    }

    // MARK: - CRUD

    func fetchItems() {
        let request = NSFetchRequest<NSManagedObject>(entityName: "CartItem")
        request.sortDescriptors = []
        do {
            let results = try context.fetch(request)
            items = results.compactMap { mo in
                guard
                    let id = mo.value(forKey: "id") as? String,
                    let name = mo.value(forKey: "name") as? String,
                    let price = mo.value(forKey: "price") as? Double,
                    let quantity = mo.value(forKey: "quantity") as? Int16
                else { return nil }
                let imageURL = mo.value(forKey: "imageURL") as? String
                let selected = mo.value(forKey: "selected") as? Bool ?? true
                let discount = mo.value(forKey: "discount") as? Double
                return CartProduct(id: id, name: name, price: price, quantity: Int(quantity), imageURL: imageURL, selected: selected, discount: discount)
            }
        } catch {
            print("fetchItems error: \(error)")
            items = []
        }
    }

    func add(productId: String, name: String, price: Double, imageURL: String? = nil, discount: Double? = nil, quantity: Int = 1) {
        // If exists: increment quantity
        if let index = items.firstIndex(where: { $0.id == productId }) {
            let newQty = items[index].quantity + quantity
            updateQuantity(id: productId, quantity: newQty)
            return
        }

        let mo = NSEntityDescription.insertNewObject(forEntityName: "CartItem", into: context)
        mo.setValue(productId, forKey: "id")
        mo.setValue(name, forKey: "name")
        mo.setValue(price, forKey: "price")
        mo.setValue(Int16(quantity), forKey: "quantity")
        mo.setValue(imageURL, forKey: "imageURL")
        mo.setValue(true, forKey: "selected")
        if let d = discount { mo.setValue(d, forKey: "discount") }

        CartPersistence.shared.saveContext()
        fetchItems()
    }

    func updateQuantity(id: String, quantity: Int) {
        guard let mo = fetchManagedObject(id: id) else { return }
        mo.setValue(Int16(max(1, quantity)), forKey: "quantity")
        CartPersistence.shared.saveContext()
        fetchItems()
    }

    func toggleSelected(id: String) {
        guard let mo = fetchManagedObject(id: id) else { return }
        let current = (mo.value(forKey: "selected") as? Bool) ?? true
        mo.setValue(!current, forKey: "selected")
        CartPersistence.shared.saveContext()
        fetchItems()
    }

    func delete(id: String) {
        guard let mo = fetchManagedObject(id: id) else { return }
        context.delete(mo)
        CartPersistence.shared.saveContext()
        fetchItems()
    }

    func clearAll() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CartItem")
        let batch = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.execute(batch)
            CartPersistence.shared.saveContext()
            fetchItems()
        } catch {
            print("clearAll error: \(error)")
        }
    }

    // Helpers
    private func fetchManagedObject(id: String) -> NSManagedObject? {
        let request = NSFetchRequest<NSManagedObject>(entityName: "CartItem")
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1
        do {
            return try context.fetch(request).first
        } catch {
            print("fetchManagedObject error: \(error)")
            return nil
        }
    }

    // Computed subtotal only for selected items
    var subtotal: Double {
        items.filter { $0.selected }.reduce(0) { $0 + ($1.effectivePrice * Double($1.quantity)) }
    }
}
