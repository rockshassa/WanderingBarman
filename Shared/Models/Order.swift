//
//  Cart.swift
//  WanderingBarman (iOS)
//
//  Created by Nick on 12/3/20.
//

import Foundation
import Combine

class OrderItem: UIObservable, Codable, CustomStringConvertible, Hashable {
    static func == (lhs: OrderItem, rhs: OrderItem) -> Bool {
        return lhs.description == rhs.description
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(menuItem)
    }

    let menuItem: MenuItem
    var quantity: Int

    init(item: MenuItem, quantity: Int = 1) {
        self.menuItem = item
        self.quantity = quantity
        super.init()
    }
    
    var priceString: String? {
        let dec = menuItem.price as NSDecimalNumber
        let qty = NSDecimalNumber(integerLiteral: quantity)
        let sum = dec.multiplying(by: qty)
        let priceString = MenuItem.currencyFormatter.string(from: sum)
        return priceString
    }
}

class Order: UIObservable, Codable, CustomStringConvertible {

    @Published var items = [OrderItem]()

    var id = randomString()

    override init() {
        super.init()
    }

    enum CodingKeys: String, CodingKey {
        case id
        case items
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        items = try values.decode([OrderItem].self, forKey: .items)
        id = try values.decode(String.self, forKey: .id)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(items, forKey: .items)
        try container.encode(id, forKey: .id)
    }

    static var currentOrder = Order()

    static var dummyOrder: Order {
        let o = Order()
        let orderItems = Menu.allItems.map { (menuItem) -> OrderItem in
            return OrderItem(item: menuItem, quantity: 2)
        }
        o.items = orderItems
        return o
    }
}

class UIObservable: ObservableObject {
    public var objectWillChange = PassthroughSubject<Void, Never>()

    func push() {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
}

extension Order {
    var total: NSDecimalNumber {
        var tot = 0 as NSDecimalNumber
        for item in items {
            tot = tot.adding(NSDecimalNumber(decimal: item.menuItem.price * Decimal(item.quantity)))
        }
        return tot
    }

    var totalString: String? {
        let dec = total as NSDecimalNumber
        let priceString = MenuItem.currencyFormatter.string(from: dec)
        return priceString
    }

    func add(_ item: MenuItem) {
        if let match = items.filter({ $0.menuItem.sku == item.sku }).first {
            match.quantity += item.quantity
            match.push()
        } else {
            let orderItem = OrderItem(item: item)
            orderItem.quantity = item.quantity
            items.append(orderItem)
        }
        push() //dont move this
    }
    
    var quantityForBadge: Int {
        return items.reduce(0) { (result, orderItem) -> Int in
            return result + orderItem.quantity
        }
    }

    var orderText: String {

        let account = Account.current

        var text = ""

        // Deliver to
        text.append("Deliver ASAP to:")
        text.append("\n")
        text.append(account.fullName)
        text.append("\n")
        text.append("\(account.addressStreet) \(account.addressStreet2)")
        text.append("\n")
        text.append("\(account.addressCity), \(account.addressState) \(account.addressZip)")
        text.append("\n")
        text.append(account.phone)
        text.append("\n")

        // Items
        for item in items {
            text.append("\n")
            text.append("\(item.menuItem.title) x \(item.quantity)")
        }
        text.append("\n")
        text.append("TOTAL: \(totalString!)")

        // Order ID
        text.append("\n")
        text.append("Order ID: \(id)")

        return text
    }
}

func randomString(length: Int = 16) -> String {
    let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map { _ in letters.randomElement()! })
}
