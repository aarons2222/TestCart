//
//  BaseDiscount.swift
//
//
//  Created by Aaron Strickland on 16/08/2024.
//

import Foundation

/// Base class for all discount types.
/// Provides common functionality and requires subclasses to implement the `apply` method.
class BaseDiscount: Discount {
    
    /// Method to apply a discount to a basket.
    /// Must be overridden by subclasses.
    func apply(to basket: Basket, excluding excludedProductIds: Set<String>) -> (total: Double, appliedProductIds: Set<String>) {
        let message = "Error: Subclasses need to implement the `apply` method."
        Logger.shared.log(message, level: .error)
        fatalError(message)  // Ensures that this method is never called directly on the base class.
    }

    /// Filters the basket items to include only those that match the provided product IDs and are not excluded.
    /// Also ensures the items have a non-zero price.
    func filterApplicableItems(for productIds: [String], in basket: Basket, excluding excludedProductIds: Set<String>) -> [BasketItem] {
        Logger.shared.log("Filtering applicable items for product IDs: \(productIds) excluding: \(excludedProductIds)", level: .debug)
        return basket.items.filter { productIds.contains($0.product.id) && !excludedProductIds.contains($0.product.id) && $0.product.price > 0 }
    }

    /// Helper methods for logging at various levels.
    func logError(_ message: String) {
        Logger.shared.log(message, level: .error)
    }

    func logInfo(_ message: String) {
        Logger.shared.log(message, level: .info)
    }

    func logDebug(_ message: String) {
        Logger.shared.log(message, level: .debug)
    }
}
