import XCTest
@testable import TestCartLib

class BasketTests: XCTestCase {
    var iPhone: Product!
    var macBook: Product!
    var appleWatch: Product!
    var iPad: Product!
    var basket: Basket!
    
    
    override func setUp() {
        super.setUp()
        
        let electronicsCategory = Category(id: "1", name: "Electronics")
        
        iPhone = Product(id: "001", name: "iPhone", price: 999.0, category: electronicsCategory)
        macBook = Product(id: "002", name: "MacBook", price: 1299.0, category: electronicsCategory)
        appleWatch = Product(id: "003", name: "Apple Watch", price: 399.0, category: electronicsCategory)
        iPad = Product(id: "004", name: "iPad", price: 499.0, category: electronicsCategory)
        
        basket = Basket()
        print("Setup completed: Products initialised and empty basket created.")
    }
    
    
    
    
    // Helper method to add products and print the action
    func addProductToBasket(_ product: Product, quantity: Int) {
        basket.addProduct(product, quantity: quantity)
        print("Added \(quantity) \(product.name)(s) to the basket.")
    }
    
    // Helper method to apply discounts and print the resulting total
    func applyDiscountsAndPrintTotal(_ discounts: [Discount]) -> Double {
        let total = basket.applyDiscounts(discounts)
        print("Applied discounts. Basket total: £\(total)")
        return total
    }
    
    
    
    
    
    func testOnlyOneDiscountApplied() {
        addProductToBasket(iPhone, quantity: 3)
        
        
        let discount1 = BuyXGetYFree(productId: "001", requiredQuantity: 2, freeQuantity: 1)
        var total = applyDiscountsAndPrintTotal([discount1])
        XCTAssertEqual(total, 1998.0, "Expected total after BuyXGetYFree to be £1998, but got £\(total)")
        
        basket = Basket() 
        
        addProductToBasket(iPhone, quantity: 3)
        
        let discount2 = ProductSpecificDiscount(productId: "001", percentage: 10)
        total = applyDiscountsAndPrintTotal([discount2])
        XCTAssertEqual(total, 2697.30, "Expected total after ProductSpecificDiscount to be £2697.30, but got £\(total)")
    }

    func testAddProductToBasket() {
        addProductToBasket(macBook, quantity: 1)
        
        XCTAssertEqual(basket.items.count, 1, "Expected basket to have 1 item, it has \(basket.items.count)")
        XCTAssertEqual(basket.items.first?.quantity, 1, "Expected the quantity of the first item to be 1, it is \(basket.items.first?.quantity ?? 0)")
        
        print("Basket contains \(basket.items.count) item(s) with quantity \(basket.items.first?.quantity ?? 0).")
    }
    
    func testGeneralBasketDiscount() {
        
        addProductToBasket(macBook, quantity: 1)
        addProductToBasket(iPad, quantity: 1)
        
        let discount = GeneralBasketDiscount(percentage: 5)
        let total = applyDiscountsAndPrintTotal([discount])
        XCTAssertEqual(total, 1708.10, "Expected total after GeneralBasketDiscount to be £1708.10, but got £\(total)")
    }
    
    func testProductSpecificDiscount() {
        addProductToBasket(appleWatch, quantity: 2)
        
        let discount = ProductSpecificDiscount(productId: "003", percentage: 15)
        let total = applyDiscountsAndPrintTotal([discount])
        XCTAssertEqual(total, 678.30, "Expected total after ProductSpecificDiscount to be £678.30, but got £\(total)")
    }
    
    func testBuyXGetYFree() {
        addProductToBasket(iPad, quantity: 4)
        
        let discount = BuyXGetYFree(productId: "004", requiredQuantity: 3, freeQuantity: 1)
        let total = applyDiscountsAndPrintTotal([discount])
        XCTAssertEqual(total, 1497.0, "Expected total after BuyXGetYFree to be £1497.0, but got £\(total)")
    }
    
    func testCombinationDealDiscount() {
        addProductToBasket(macBook, quantity: 1)
        addProductToBasket(iPad, quantity: 1)
        addProductToBasket(appleWatch, quantity: 1)
        
        let discount = CombinationDealDiscount(productIds: ["002", "004", "003"], dealPrice: 1690.0)
        let total = applyDiscountsAndPrintTotal([discount])
        XCTAssertEqual(total, 1690.0, "Expected total after CombinationDealDiscount to be £1690.0, but got £\(total)")
    }
}
