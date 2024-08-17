//
//  GeneralBasketDiscount.swift
//  
//
//  Created by Aaron Strickland on 16/08/2024.
//


/// Discount  applies a percentage off  entire basket.
final class GeneralBasketDiscount: BaseDiscount {
    private let percentage: Double

    ///  discount with a percentage to apply to  basket.
    init(percentage: Double) {
        self.percentage = percentage
        super.init()
        logInfo("Initialised GeneralBasketDiscount with \(percentage)% off.")
    }

    /// Applies the discount to the entire basket.
    /// Returns the updated total and the IDs of products the discount was applied to.
    override func apply(to basket: Basket, excluding excludedProductIds: Set<String>) -> (total: Double, appliedProductIds: Set<String>) {
        logInfo("Applying GeneralBasketDiscount of \(percentage)% to the basket.")

        // return if the basket is empty.
        guard !basket.items.isEmpty else {
            logInfo("Basket is empty. No discounts applied.")
            return (basket.calculateTotal(), Set<String>())
        }

        // Get applicable items from basket.
        let applicableItems = filterApplicableItems(for: basket.items.map { $0.product.id }, in: basket, excluding: excludedProductIds)
        guard !applicableItems.isEmpty else {
            logInfo("No applicable items in the basket for GeneralBasketDiscount. Discount not applied.")
            return (basket.calculateTotal(), Set<String>())
        }

        // Calculate discount and ensure total does not become negative.
        let discountAmount = basket.calculateTotal() * (percentage / 100)
        let finalTotal = max(0, basket.calculateTotal() - discountAmount)

        logInfo("Discount amount: £\(discountAmount), final total: £\(finalTotal)")

        return (finalTotal, Set(applicableItems.map { $0.product.id }))
    }
}

