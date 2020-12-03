//
//  Cart.swift
//  WanderingBarman (iOS)
//
//  Created by Nick on 12/3/20.
//

import Foundation

struct Order {
    static var currentOrder = Order()
    var items = [OrderItem]()
}

struct OrderItem: Identifiable {
    let item:MenuItem
    var quantity:Int = 0
    var id: ObjectIdentifier = ObjectIdentifier(OrderItem.Type.self)
}

struct MenuItem: Identifiable, Hashable {
    var id: ObjectIdentifier = ObjectIdentifier(MenuItem.Type.self)
    
    static var dummyItems:[MenuItem] {
        return [MenuItem(),MenuItem(),MenuItem(),MenuItem(),MenuItem(),MenuItem(),MenuItem(),MenuItem()]
    }
    
    var title = "La Niña Margarita"
    var price:Decimal = 5.00
    var description = "An elevated botanical Margarita with marigold & kaffir lime"
    var size = "3.4oz"
    var abv = "18"
    var imageName = "la_nina"
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(price)
        hasher.combine(description)
        hasher.combine(size)
        hasher.combine(abv)
        hasher.combine(imageName)
    }
}
