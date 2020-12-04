//
//  Menu.swift
//  WanderingBarman
//
//  Created by Nick on 12/3/20.
//

import SwiftUI

var imageSize:CGFloat = 80

struct ItemRow : View {
    
    var item:MenuItem
    
    init(_ item:MenuItem) {
        self.item = item
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(item.imageName).resizable()
                    .frame(width: imageSize, height: imageSize)
                    .aspectRatio(contentMode: .fit)
                VStack {
                    Text(item.title).bold()
                    Text(item.itemDescription).italic()
                    Text("\(item.size) / \(item.abv)% abv")
                        .multilineTextAlignment(.leading)
                }
            }
            Button("Add to Cart") {
                Order.currentOrder.add(item)
            }.buttonStyle(BorderlessButtonStyle())
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

struct MenuView: View {
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

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
