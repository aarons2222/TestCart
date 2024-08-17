//
//  ProductSpecificDiscount.swift
//  
//
//  Created by Aaron Strickland on 16/08/2024.
//


/// Discount that applies a percentage off a specific product in the basket.
final class ProductSpecificDiscount: BaseDiscount {
    private let productId: String
    private let percentage: Double

    /// Initialises the discount with the product ID and the percentage to apply.
    init(productId: String, percentage: Double) {
        self.productId = productId
        self.percentage = percentage
        super.init()
        logInfo("Initialised ProductSpecificDiscount for product \(productId) with \(percentage)% off.")
    }

    /// Applies  discount to  specified product if in  basket.
    /// Returns the updated total and the IDs of products the discount was applied to.
    override func apply(to basket: Basket, excluding excludedProductIds: Set<String>) -> (total: Double, appliedProductIds: Set<String>) {
        logInfo("Applying ProductSpecificDiscount of \(percentage)% to product \(productId).")

        // Early exit if the basket is empty.
        guard !basket.items.isEmpty else {
            logInfo("Basket is empty. No discounts applied.")
            return (basket.calculateTotal(), Set<String>())
        }

        // filter applicable items found in basket.
        let applicableItems = filterApplicableItems(for: [productId], in: basket, excluding: excludedProductIds)
        guard !applicableItems.isEmpty else {
            logInfo("No applicable items for product ID \(productId). Discount not applied.")
            return (basket.calculateTotal(), Set<String>())
        }

        // Calculate discount amount and ensure totalis not negative
        let discountAmount = applicableItems.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) * (percentage / 100) }
        let finalTotal = max(0, basket.calculateTotal() - discountAmount)

        logInfo("Discount amount for product \(productId): £\(discountAmount), final total: £\(finalTotal)")

        return (finalTotal, [productId])
    }
}

