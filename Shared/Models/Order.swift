//
//  Cart.swift
//  WanderingBarman (iOS)
//
//  Created by Nick on 12/3/20.
//

import Foundation
import Combine

class Order: NSObject, ObservableObject, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    
    var id = randomString()
    
    @Published var items = [MenuItem]()
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        self.id = coder.decodeObject(forKey: "id") as! String
        self.items = coder.decodeArrayOfObjects(ofClass: MenuItem.self, forKey: "items")!
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(items, forKey: "items")
    }
    
    static var currentOrder = Order()
    
    static var dummyOrder:Order {
        let o = Order()
        let item = MenuItem()
        item.orderQty = 1
        o.items = [item]
        return o
    }
    
    public private(set) var objectWillChange = PassthroughSubject<Void,Never>()
}

extension Order {
    
    var total:NSDecimalNumber {
        var tot = 0 as NSDecimalNumber
        for item in items {
            tot = tot.adding(item.price)
        }
        return tot
    }
    
    var totalString:String? {
        // We'll force unwrap with the !, if you've got defined data you may need more error checking
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
