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
    static var allItems: [MenuItem] {
        return [
            MenuItem(sku: "00001",
                     title: "Iron Lady",
                     price: 10,
                     shortDesc: "Rose Gin & Hops Sling",
                     longDesc: "Rose and citrus provide a floral refreshing start, followed by the hops’ delicate, bitter dry finish.",
                     size: "3.4oz",
                     abv: "20",
                     imageName: "iron_lady"),
            MenuItem(sku: "00002",
                     title: "La Niña",
                     price: 10,
                     shortDesc: "Marigold & Kaffir Lime Margarita",
                     longDesc: "Marigold and Kaffir Lime bring a botanical twist to this refined style of Margarita.",
                     size: "3.4oz",
                     abv: "20",
                     imageName: "la_nina"),
            MenuItem(sku: "00003",
                     title: "Swipe Right",
                     price: 10,
                     shortDesc: "Date-infused Old Fashioned",
                     longDesc: "All natural dates replace sugar in this take on a classic infused in bourbon and pared with aromatic and orange bitters.",
                     size: "3.4oz",
                     abv: "20",
                     imageName: "swipe_right"),
            MenuItem(sku: "00004",
                     title: "FOMO",
                     price: 10,
                     shortDesc: "Organic Vodka Pineapple Sling",
                     longDesc: "Pineapple and turmeric combine to create an earthy yet refreshing tropical profile, backed up with a touch of heat from the flavorful Hatch Green Chile.",
                     size: "3.4oz",
                     abv: "20",
                     imageName: "fomo")
        ]
    }
}

class MenuItem: UIObservable, Identifiable, Codable, CustomStringConvertible, Hashable {
    
    static func == (lhs: MenuItem, rhs: MenuItem) -> Bool {
        return lhs.sku == rhs.sku
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(sku)
    }

    let sku: String
    let title: String
    let price: Decimal
    let shortDesc: String
    let longDesc: String
    let size: String
    let abv: String
    let imageName: String
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case sku
        case title
        case price
        case longDesc
        case shortDesc
        case size
        case abv
        case imageName
        case imageURL
    }

    init(sku: String, title: String, price: Decimal, shortDesc:String, longDesc: String, size: String, abv: String, imageName: String, imageURL: String = "") {
        self.sku = sku
        self.title = title
        self.price = price
        self.shortDesc = shortDesc
        self.longDesc = longDesc
        self.size = size
        self.abv = abv
        self.imageName = imageName
        self.imageURL = imageURL
    }
    
    var id = UUID()

    static let currencyFormatter: NumberFormatter = {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        // localize to your grouping and decimal separator
        currencyFormatter.locale = Locale.current
        return currencyFormatter
    }()

    var priceString: String? {
        // We'll force unwrap with the !, if you've got defined data you may need more error checking
        let dec = price as NSDecimalNumber
        let priceString = MenuItem.currencyFormatter.string(from: dec)
        return priceString
    }
}
