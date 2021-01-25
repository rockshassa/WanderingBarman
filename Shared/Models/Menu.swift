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
extension Menu {
    static var allItems:[MenuItem] {
        return [
            MenuItem(title: "La Niña Margarita", price: 5, description: "An elevated botanical Margarita with marigold & kaffir lime", size: "3.4oz", abv: "18", imageName: "la_nina", imageURL: "")
        ]
    }
}

struct MenuItem: Identifiable, Codable, Hashable, CustomStringConvertible {
    
    let title:String
    var price:Decimal
    var itemDescription:String
    var size:String
    var abv:String
    var imageName:String
    var imageURL:String
    var quantity:Int
    
    enum CodingKeys: String, CodingKey {
        case title
        case price
        case itemDescription
        case size
        case abv
        case quantity
        case imageName
        case imageURL
    }
    
    init(title:String, price:Decimal, description:String, size:String, abv:String, imageName:String, imageURL:String, quantity:Int = 1){
        self.title = title
        self.price = price
        self.itemDescription = description
        self.size = size
        self.abv = abv
        self.imageName = imageName
        self.imageURL = imageURL
        self.quantity = quantity
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(title, forKey: "title")
        coder.encode(price, forKey: "price")
        coder.encode(itemDescription, forKey: "itemDescription")
        coder.encode(size, forKey: "size")
        coder.encode(abv, forKey: "abv")
        coder.encode(imageName, forKey: "imageName")
        coder.encode(quantity, forKey: "quantity")
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        price = try values.decode(Decimal.self, forKey: .price)
        itemDescription = try values.decode(String.self, forKey: .itemDescription)
        size = try values.decode(String.self, forKey: .size)
        abv = try values.decode(String.self, forKey: .abv)
        imageName = try values.decode(String.self, forKey: .imageName)
        quantity = try values.decode(Int.self, forKey: .quantity)
        imageURL = try values.decode(String.self, forKey: .imageURL)
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
        return Menu.allItems
    }
    
    var priceString:String? {
        // We'll force unwrap with the !, if you've got defined data you may need more error checking
        let dec = price as NSDecimalNumber
        let priceString = MenuItem.currencyFormatter.string(from: dec)
        return priceString
    }
}
