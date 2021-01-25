//
//  MenuItem.swift
//  WanderingBarman (iOS)
//
//  Created by Nick on 12/3/20.
//

import Foundation

struct Menu: Codable {
    var items = [MenuItem]()
    var date = Date()
}

struct MenuItem: Identifiable, Codable, Hashable, CustomStringConvertible {
    
    static func == (lhs: MenuItem, rhs: MenuItem) -> Bool {
        return lhs.description == rhs.description
    }
    
    var title = "La Niña Margarita"
    var price:Decimal = 5.00
    var itemDescription = "An elevated botanical Margarita with marigold & kaffir lime"
    var size = "3.4oz"
    var abv = "18"
    var imageName = "la_nina"
    var orderQty:Int = 1
    
    enum CodingKeys: String, CodingKey {
        case title
        case price
        case itemDescription
        case size
        case abv
        case orderQty
        case imageName
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(title, forKey: "title")
        coder.encode(price, forKey: "price")
        coder.encode(itemDescription, forKey: "itemDescription")
        coder.encode(size, forKey: "size")
        coder.encode(abv, forKey: "abv")
        coder.encode(imageName, forKey: "imageName")
        coder.encode(orderQty, forKey: "orderQty")
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        price = try values.decode(Decimal.self, forKey: .price)
        itemDescription = try values.decode(String.self, forKey: .itemDescription)
        size = try values.decode(String.self, forKey: .size)
        abv = try values.decode(String.self, forKey: .abv)
        imageName = try values.decode(String.self, forKey: .imageName)
        orderQty = try values.decode(Int.self, forKey: .orderQty)
    }
    
    init() {
    }
    
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
    
    var priceString:String? {
        // We'll force unwrap with the !, if you've got defined data you may need more error checking
        let dec = price as NSDecimalNumber
        let priceString = MenuItem.currencyFormatter.string(from: dec)
        return priceString
    }
}
