//
//  Cart.swift
//  WanderingBarman (iOS)
//
//  Created by Nick on 12/3/20.
//

import Foundation

struct Order {
    var items = [OrderItem]()
}

struct OrderItem {
    let item:MenuItem
    var quantity:Int = 0
}

struct Cart {
    static var currentOrder = Order()
}

struct MenuItem: Identifiable {
    var id: ObjectIdentifier = ObjectIdentifier(MenuItem.Type.self)
    
    static var dummyItems:[MenuItem] {
        return [MenuItem(),MenuItem(),MenuItem(),MenuItem(),MenuItem(),MenuItem(),MenuItem(),MenuItem()]
    }
    
    var title = "La Niña Margarita"
    var price:Decimal = 5.00
    var description = "An elevated botanical Margarita with marigold & kaffir lime"
    var size:String = "3.4oz"
    var abv:String = "18"
    var imageName = "la_nina"
}
