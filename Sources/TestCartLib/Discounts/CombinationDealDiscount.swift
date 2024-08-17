//
//  CombinationDealDiscount.swift
//  
//
//  Created by Aaron Strickland on 16/08/2024.
//


/// Discount that applies a special deal price if all specified products are in basket.
final class CombinationDealDiscount: BaseDiscount {
    private let productIds: [String]
    private let dealPrice: Double

    /// Initialises  discount with the product IDs and  deal price.
    init(productIds: [String], dealPrice: Double) {
        self.productIds = productIds
        self.dealPrice = dealPrice
        super.init()
        logInfo("Initialised CombinationDealDiscount for products \(productIds) with deal price £\(dealPrice).")
    }

    /// Applies the discount if all specified products are present in the basket.
    /// Returns the updated total and  IDs of products that the  discount was applied to.
    override func apply(to basket: Basket, excluding excludedProductIds: Set<String>) -> (total: Double, appliedProductIds: Set<String>) {
        logInfo("Applying CombinationDealDiscount for products \(productIds).")

        // Return if basket is empty.
        guard !basket.items.isEmpty else {
            logInfo("Basket is empty. No discounts applied.")
            return (basket.calculateTotal(), Set<String>())
        }

        // Filter the basket for applicable items.
        let applicableItems = filterApplicableItems(for: productIds, in: basket, excluding: excludedProductIds)
        let hasAllProducts = productIds.allSatisfy { id in applicableItems.contains(where: { $0.product.id == id }) }

        // If all required products are not present, return original total.
        guard hasAllProducts else {
            logInfo("CombinationDealDiscount not applied. Returning original basket total.")
            return (basket.calculateTotal(), Set<String>())
        }

        // Calculate total after applying deal price.
        let totalRegularPrice = applicableItems.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
        let finalTotal = max(0, basket.calculateTotal() - totalRegularPrice + dealPrice)

        logInfo("Total regular price: £\(totalRegularPrice), final total: £\(finalTotal)")

        return (finalTotal, Set(productIds))
    }
}

