//
//  Menu.swift
//  WanderingBarman (iOS)
//
//  Created by Nick on 12/3/20.
//

import Foundation

struct MenuItem: Identifiable, Hashable {
    var id: ObjectIdentifier = ObjectIdentifier(MenuItem.Type.self)
    
    static let currencyFormatter:NumberFormatter = {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        // localize to your grouping and decimal separator
        currencyFormatter.locale = Locale.current
        return currencyFormatter
    }()
    
    static var dummyItems:[MenuItem] {
        return [MenuItem(),MenuItem(),MenuItem(),MenuItem(),MenuItem(),MenuItem(),MenuItem(),MenuItem()]
    }
    
    var title = "La Niña Margarita"
    var price:Decimal = 5.00
    var priceString:String? {
        // We'll force unwrap with the !, if you've got defined data you may need more error checking
        let dec = price as NSDecimalNumber
        let priceString = MenuItem.currencyFormatter.string(from: dec)
        return priceString
    }
    var description = "An elevated botanical Margarita with marigold & kaffir lime"
    var size = "3.4oz"
    var abv = "18"
    var imageName = "la_nina"
    var orderQty = 0
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(price)
        hasher.combine(description)
        hasher.combine(size)
        hasher.combine(abv)
        hasher.combine(imageName)
    }
}
