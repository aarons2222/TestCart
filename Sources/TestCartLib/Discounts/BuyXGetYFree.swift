//
//  BuyXGetYFree.swift
//
//
//  Created by Aaron Strickland on 16/08/2024.
//

import Foundation

/// Discount where buying a certain quantity of a product gives the customer additional items for free.
final class BuyXGetYFree: BaseDiscount {
    private let productId: String
    private let requiredQuantity: Int
    private let freeQuantity: Int

    /// Discount with the product ID, required quantity for the offer, and the number of free items.
    init(productId: String, requiredQuantity: Int, freeQuantity: Int) {
        self.productId = productId
        self.requiredQuantity = requiredQuantity
        self.freeQuantity = freeQuantity
        super.init()
        logInfo("Initialised BuyXGetYFree discount for product \(productId): Buy \(requiredQuantity), get \(freeQuantity) free.")
    }

    /// Applies the discount to the basket if the conditions are met.
    /// Returns the updated total and the IDs of products the discount was applied to.
    override func apply(to basket: Basket, excluding excludedProductIds: Set<String>) -> (total: Double, appliedProductIds: Set<String>) {
        logInfo("Applying BuyXGetYFree discount for product \(productId).")

        // Early exit if the basket is empty.
        guard !basket.items.isEmpty else {
            logInfo("Basket is empty. No discounts applied.")
            return (basket.calculateTotal(), Set<String>())
        }

        // Get the applicable items from the basket.
        let applicableItems = filterApplicableItems(for: [productId], in: basket, excluding: excludedProductIds)
        guard !applicableItems.isEmpty else {
            logInfo("No applicable items for product ID \(productId). Discount not applied.")
            return (basket.calculateTotal(), Set<String>())
        }

        // Calculate the number of free items and the discount amount.
        let totalQuantity = applicableItems.reduce(0) { $0 + $1.quantity }
        let freeItems = max(0, (totalQuantity / requiredQuantity) * freeQuantity)

        // Ensure the total cannot be negative after applying the discount.
        let discountAmount = Double(freeItems) * (applicableItems.first?.product.price ?? 0)
        let finalTotal = max(0, basket.calculateTotal() - discountAmount)

        logInfo("Calculated free items: \(freeItems), discount amount: £\(discountAmount), final total: £\(finalTotal)")

        return (finalTotal, [productId])
    }
}

