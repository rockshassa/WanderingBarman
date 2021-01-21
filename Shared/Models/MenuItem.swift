//
//  MenuItem.swift
//  WanderingBarman (iOS)
//
//  Created by Nick on 12/3/20.
//

import Foundation

class MenuItem: NSObject, Identifiable, NSSecureCoding, Codable {

    static var supportsSecureCoding: Bool = true
    
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

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        price = try values.decode(Decimal.self, forKey: .price)
        itemDescription = try values.decode(String.self, forKey: .itemDescription)
        size = try values.decode(String.self, forKey: .size)
        abv = try values.decode(String.self, forKey: .abv)
        imageName = try values.decode(String.self, forKey: .imageName)
        orderQty = try values.decode(Int.self, forKey: .orderQty)
    }
    
    required init?(coder: NSCoder) {
        self.title = coder.decodeObject(forKey: "title") as! String
//        self.price = coder.decodeObject(of: Decimal.self, forKey: "price")!
        self.itemDescription = coder.decodeObject(forKey: "itemDescription") as! String
        self.size = coder.decodeObject(forKey: "size") as! String
        self.abv = coder.decodeObject(forKey: "abv") as! String
        self.imageName = coder.decodeObject(forKey: "imageName") as! String
        self.orderQty = coder.decodeInteger(forKey: "orderQty")
    }
    
    override init() {
        super.init()
    }
    
    func encode(to encoder: Encoder) throws {
        
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
