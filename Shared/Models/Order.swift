//
//  Cart.swift
//  WanderingBarman (iOS)
//
//  Created by Nick on 12/3/20.
//

import Foundation
import Combine

class OrderItem: ObservableObject, Codable, CustomStringConvertible, Hashable {
    static func == (lhs: OrderItem, rhs: OrderItem) -> Bool {
        return lhs.description == rhs.description
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(menuItem)
    }
    
    let menuItem:MenuItem
    var quantity:Int
    
    init(item:MenuItem, quantity:Int = 1) {
        self.menuItem = item
        self.quantity = quantity
    }
}

class Order: ObservableObject, Codable, CustomStringConvertible {
    
    public private(set) var objectWillChange = PassthroughSubject<Void,Never>()
    @Published var items = [OrderItem]()
    
    var id = randomString()
    
    init() {
        
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
    
    static var dummyOrder:Order {
        let o = Order()
        let item = OrderItem(item: MenuItem())
        o.items = [item]
        return o
    }
}

extension Order {
    var total:NSDecimalNumber {
        var tot = 0 as NSDecimalNumber
        for item in items {
            tot = tot.adding(NSDecimalNumber(decimal: item.menuItem.price))
        }
        return tot
    }
    
    var totalString:String? {
        let dec = total as NSDecimalNumber
        let priceString = MenuItem.currencyFormatter.string(from: dec)
        return priceString
    }
    
    func add(_ item:MenuItem){
        let orderItem = OrderItem(item: item)
        items.append(orderItem)
        push()
    }
    
    func push() {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    var orderText:String {
        
        let account = Account.current
        
        var text = ""
        
        //Deliver to
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
        
        //Items
        for item in items {
            text.append("\n")
            text.append("\(item.menuItem.title) x \(item.menuItem.orderQty)")
        }
        text.append("\n")
        text.append("TOTAL: \(totalString!)")
        
        //Order ID
        text.append("\n")
        text.append("Order ID: \(id)")
        
        return text
    }
}



func randomString(length: Int = 16) -> String {
  let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  return String((0..<length).map{ _ in letters.randomElement()! })
}
