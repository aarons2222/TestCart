# **Shopping Cart System - Technical Document**

**Created by:** Aaron Strickland  
**Date:** 16/08/2024

## **Contents**
1. [Project Overview](#project-overview)
2. [Architecture](#architecture)
3. [Core Components](#core-components)
4. [Discount System](#discount-system)
5. [Edge Cases](#edge-cases)
6. [Logging and Debugging](#logging-and-debugging)
7. [Future Extensions](#future-extensions)

---

## **Overview**

This project models a shopping cart system that allows multiple products to be added to a basket, with support for various discounts. The system is designed for flexibility, maintainability, and extensibility, supporting product categories, applying discounts, and logging actions.


## **Architecture**

The project is modular and object-oriented, with core components such as `Basket`, `Product`, `Category`, and `Discount`. The system is easily extendable to add new discount types.

- **Design Pattern**: Simplified MVVM, where `Basket` manages state and discounts handle business logic.


## **Core Components**

### **Basket**
- **Manages items in the basket**: Tracks products and calculates totals.
- **Key Methods**:
  - `addProduct`: Adds or updates product quantities.
  - `calculateTotal`: Returns the total price of items.
  - `applyDiscounts`: Applies discounts and returns the final total.

### **Product**
- **Represents a product**: Includes properties like `id`, `name`, `price`, and `category`.

### **Category**
- **Organises products**: Helps manage and potentially apply category-based discounts.

### **Discount**
- **Defines discount logic**: The `Discount` protocol requires an `apply` method to modify basket totals.


## **Discount System**

### **Implemented Discounts**:
1. **GeneralBasketDiscount**: Applies a percentage discount to the entire basket.
2. **ProductSpecificDiscount**: Applies a discount to specific products.
3. **BuyXGetYFree**: Offers promotions like "Buy 2, Get 1 Free."
4. **CombinationDealDiscount**: Applies special pricing for specific product combinations.

### **Discount Logic**:
- **Single Discount Per Product**: Tracks applied discounts to prevent overlapping.
- **Sequential Application**: Discounts are applied in order, prioritising those that reduce the total.


## **Edge Cases and Assumptions**

### **Edge Cases**:
1. **Zero-Price Products**: Skipped in discount calculations.
2. **Negative Prices**: Validation recommended to prevent issues.
3. **Conflicting Discounts**: Only one discount per product is applied.
4. **Empty Basket**: Early exit in `applyDiscounts` to avoid processing.
5. **Invalid Product IDs**: Should be handled gracefully.


## **Logging and Debugging**

### **Logger Class**:
- **Logs key actions**: Tracks product additions and discount applications.
- **Debugging Tips**:
  - **Adjust log levels** for more detailed information during development.
  - **Review error logs** to quickly identify issues.


## **Future Extensions**

### **Potential Improvements**:
1. **Category-Based Discounts**: Apply discounts to entire categories.
2. **Persistent Basket**: Save and restore basket state across sessions.
3. **Multi-Currency Support**: Handle different currencies and exchange rates.
4. **Discount Expiry**: Implement expiry dates for discounts.
5. **Enhanced Logging**: Support for logging to files or external services.

