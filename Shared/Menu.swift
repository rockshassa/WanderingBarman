//
//  Menu.swift
//  WanderingBarman
//
//  Created by Nick on 12/3/20.
//

import SwiftUI

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

var imageSize:CGFloat = 120

struct ItemRow : View {
    var item:MenuItem
    
    init(_ item:MenuItem) {
        self.item = item
    }
    var body: some View {
        HStack {
            Image(item.imageName).resizable()
                .frame(width: imageSize, height: imageSize)
                .aspectRatio(contentMode: .fit)
            VStack {
                Text(item.title).bold()
                Text(item.description).italic()
                Text("\(item.size) / \(item.abv)% abv")
                    .multilineTextAlignment(.leading)
            }
        }
    }
}

struct MenuSectionHeader: View {
    var body: some View {
        VStack {
            Text("HANDCRAFTED COCKTAILS")
                .font(.headline)
            Text("bottled by Wandering Barman")
                .font(.subheadline)
        }
    }
}

struct Menu: View {
    var body: some View {
        VStack {
            Section(header: MenuSectionHeader()) {
                List(MenuItem.dummyItems) { item in
                    ItemRow(item)
                }
            }
        }
    }
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
    }
}
