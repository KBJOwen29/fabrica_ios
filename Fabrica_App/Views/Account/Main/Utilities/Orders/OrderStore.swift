//
//  OrderStore.swift
//  Fabrica_App
//
//  Created by STUDENT on 11/18/25.
//

import SwiftUI

struct Order: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let price: Double
    let quantity: Int
    let imageName: String?
    var rating: Int?  // nil if not yet rated
    let purchasedAt: Date
}

final class OrderStore: ObservableObject {
    static let shared = OrderStore()

    // Persist orders per account (email key, lowercased-trimmed)
    @Published private(set) var ordersByEmail: [String: [Order]] = [:]

    private let storageKey = "orders_by_email.v1"

    private init() {
        load()
    }

    // MARK: - Key helpers
    private func key(for email: String) -> String {
        email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    private var currentEmail: String? {
        AuthService.shared.currentUser?.getEmail()
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
    }

    // MARK: - Accessors
    func orders(for email: String) -> [Order] {
        ordersByEmail[key(for: email)] ?? []
    }

    func unratedOrders(for email: String) -> [Order] {
        orders(for: email).filter { $0.rating == nil }
    }

    func ratedOrders(for email: String) -> [Order] {
        orders(for: email).filter { $0.rating != nil }
    }

    // Current-user convenience
    var currentOrders: [Order] {
        guard let e = currentEmail else { return [] }
        return orders(for: e)
    }

    var currentUnratedOrders: [Order] {
        guard let e = currentEmail else { return [] }
        return unratedOrders(for: e)
    }

    var currentRatedOrders: [Order] {
        guard let e = currentEmail else { return [] }
        return ratedOrders(for: e)
    }

    // MARK: - Mutations
    func addOrders(for email: String, from products: [CartProduct]) {
        guard !products.isEmpty else { return }
        let k = key(for: email)
        var list = ordersByEmail[k] ?? []
        let now = Date()
        let new: [Order] = products.map { p in
            Order(
                id: UUID().uuidString,
                name: p.name,
                price: p.effectivePrice,          // use effective price (after discount) if available
                quantity: p.quantity,
                imageName: p.imageURL,
                rating: nil,
                purchasedAt: now
            )
        }
        list.append(contentsOf: new)
        ordersByEmail[k] = list
        save()
        objectWillChange.send()
    }

    // Convenience for current signed-in account
    func addOrdersForCurrentUser(from products: [CartProduct]) {
        guard let e = currentEmail else { return }
        addOrders(for: e, from: products)
    }

    func rate(orderId: String, for email: String, rating: Int) {
        let k = key(for: email)
        guard var list = ordersByEmail[k],
              let idx = list.firstIndex(where: { $0.id == orderId }) else { return }
        list[idx].rating = rating
        ordersByEmail[k] = list
        save()
        objectWillChange.send()
    }

    func rateCurrentUser(orderId: String, rating: Int) {
        guard let e = currentEmail else { return }
        rate(orderId: orderId, for: e, rating: rating)
    }

    // MARK: - Persistence
    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }
        if let decoded = try? JSONDecoder().decode([String: [Order]].self, from: data) {
            ordersByEmail = decoded
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(ordersByEmail) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
}
