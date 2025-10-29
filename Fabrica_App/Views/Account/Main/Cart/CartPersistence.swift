//
//  CartPersistence.swift
//  Fabrica_App
//
//  Created by STUDENT on 10/29/25.
//

import Foundation
import CoreData

final class CartPersistence {
    static let shared = CartPersistence()
    let container: NSPersistentContainer

    private init(inMemory: Bool = false) {
        let model = NSManagedObjectModel()

        // Entity: CartItem
        let cartEntity = NSEntityDescription()
        cartEntity.name = "CartItem"
        cartEntity.managedObjectClassName = "NSManagedObject"

        // Attributes
        func attr(_ name: String, type: NSAttributeType, optional: Bool = false) -> NSAttributeDescription {
            let a = NSAttributeDescription()
            a.name = name
            a.attributeType = type
            a.isOptional = optional
            return a
        }

        cartEntity.properties = [
            attr("id", type: .stringAttributeType, optional: false),
            attr("name", type: .stringAttributeType, optional: false),
            attr("price", type: .doubleAttributeType, optional: false),
            attr("quantity", type: .integer16AttributeType, optional: false),
            attr("imageURL", type: .stringAttributeType, optional: true),
            attr("selected", type: .booleanAttributeType, optional: false),
            attr("discount", type: .doubleAttributeType, optional: true) // percentage or absolute depending on your usage
        ]

        model.entities = [cartEntity]

        container = NSPersistentContainer(name: "CartModel", managedObjectModel: model)
        if inMemory {
            let desc = NSPersistentStoreDescription()
            desc.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [desc]
        }
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed saving context: \(error)")
            }
        }
    }
}
