//  Basket.swift
//
//
//  Created by Aaron Strickland on 16/08/2024.
//

import Foundation

/// Represents a shopping basket that can hold multiple items.
class Basket {

    /// The items currently in the basket. Private to prevent external modification.
    private(set) var items: [BasketItem] = []

    /// Adds a product to the basket, or updates the quantity if it's already in there.
    /// - Parameters:
    ///   - product: The product to add.
    ///   - quantity: How many of the product to add.
    func addProduct(_ product: Product, quantity: Int) {
        // Check if the product is already in the basket.
        if let existingIndex = items.firstIndex(where: { $0.product.id == product.id }) {
            // If it is, just update the quantity.
            items[existingIndex].quantity += quantity
            Logger.shared.log("Updated \(product.name) quantity to \(items[existingIndex].quantity)", level: .info)
        } else {
            // If it isn't, add it as a new item.
            let newItem = BasketItem(product: product, quantity: quantity)
            items.append(newItem)
            Logger.shared.log("Added \(quantity) \(product.name)(s) to the basket.", level: .info)
        }
    }

    /// Calculates the total cost of all the items in the basket.
    /// - Returns: The total price as a Double.
    func calculateTotal() -> Double {
        // Sum up the price of each item based on its quantity.
        let total = items.reduce(0) { subtotal, item in
            subtotal + (item.product.price * Double(item.quantity))
        }
        Logger.shared.log("Calculated basket total: £\(total)", level: .info)
        return total
    }

    /// Applies a list of discounts to the basket and returns the final total.
    /// - Parameter Discounts  array of discounts to apply.
    /// - Returns: The final total after applying discounts.
    func applyDiscounts(_ discounts: [Discount]) -> Double {
        var finalTotal = calculateTotal()
        var appliedProductIds = Set<String>()

        // Go through each discount and apply it if it reduces the total.
        for discount in discounts {
            let (discountedTotal, discountAppliedProductIds) = discount.apply(to: self, excluding: appliedProductIds)
            if discountedTotal < finalTotal {
                finalTotal = discountedTotal
                appliedProductIds.formUnion(discountAppliedProductIds)
                Logger.shared.log("Applied discount: new total is £\(finalTotal)", level: .info)
            } else {
                Logger.shared.log("Discount not applied: total remains £\(finalTotal)", level: .info)
            }
        }

        return finalTotal
    }
}
