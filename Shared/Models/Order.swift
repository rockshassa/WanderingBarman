//
//  Cart.swift
//  WanderingBarman (iOS)
//
//  Created by Nick on 12/3/20.
//

import Foundation
import Combine

class Order: ObservableObject, Codable, CustomStringConvertible {
    
    public private(set) var objectWillChange = PassthroughSubject<Void,Never>()
    @Published var items = [MenuItem]()
    
    var id = randomString()
    
    init() {
        
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case items
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        items = try values.decode([MenuItem].self, forKey: .items)
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
        var item = MenuItem()
        item.orderQty = 1
        o.items = [item]
        return o
    }
}

extension Order {
    var total:NSDecimalNumber {
        var tot = 0 as NSDecimalNumber
        for item in items {
            tot = tot.adding(NSDecimalNumber(decimal: item.price))
        }
        return tot
    }
    
    var totalString:String? {
        let dec = total as NSDecimalNumber
        let priceString = MenuItem.currencyFormatter.string(from: dec)
        return priceString
    }
    
    func add(_ item:MenuItem){
        items.append(item)
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
            text.append("\(item.title) x \(item.orderQty)")
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
