//
//  CartProduct.swift
//  Fabrica_App
//
//  Created by STUDENT on 10/29/25.
//

import Foundation

struct CartProduct: Identifiable, Equatable {
    let id: String
    var name: String
    var price: Double
    var quantity: Int
    var imageURL: String? // local image name or remote URL string
    var selected: Bool
    var discount: Double? // e.g., 0.4 for 40% off

    var effectivePrice: Double {
        if let d = discount {
            return price * (1 - d)
        }
        return price
    }

    var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        // adapt locale/currency as needed (example uses Philippines symbol in UI image — adjust)
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: effectivePrice)) ?? "\(effectivePrice)"
    }
}
