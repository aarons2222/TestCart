//
//  Discount.swift
//
//
//  Created by Aaron Strickland on 16/08/2024.
//

protocol Discount {
    func apply(to basket: Basket, excluding excludedProductIds: Set<String>) -> (total: Double, appliedProductIds: Set<String>)
}

