//
//  Cart.swift
//  WanderingBarman (iOS)
//
//  Created by Nick on 12/3/20.
//

import Foundation
import Combine

class Order: ObservableObject {
    static var currentOrder = Order()
    
    static var dummyOrder:Order {
        let o = Order()
        var item = MenuItem()
        item.orderQty = 1
        o.items = [item]
        return o
    }
    
    public private(set) var objectWillChange = PassthroughSubject<Void,Never>()
    
    @Published var items = [MenuItem]()
    
    var total:Decimal {
        return items.map({$0.price}).reduce(0,+)
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
}
