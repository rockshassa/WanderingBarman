//
//  Menu.swift
//  WanderingBarman
//
//  Created by Nick on 12/3/20.
//

import SwiftUI

struct MenuView: View {
    let dataSource = Menu.allItems
    var body: some View {
        VStack {
            Section(header: MenuSectionHeader()) {
                //item.sku is the unique identifier for the row
                List(dataSource, id:\.self) { item in
                    MenuItemRow(item)
                }
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

struct MenuItemRow: View {

    @ObservedObject var item: MenuItem

    init(_ item: MenuItem) {
        self.item = item
    }

    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            HStack(alignment: .center, spacing: 0.0) {
                Spacer()
                Image(item.imageName).scaleEffect(1.2).scaledToFill()
                Spacer()
                VStack(alignment: .center, spacing: 15.0) {
                    Text(item.title).bold().font(.title)
                    Text("\(item.size) / \(item.abv)% abv").font(.caption)
                    HStack(alignment: .center, spacing: 20.0) {
                        Button("-"){
                            let difference = item.quantity - 1
                            if difference >= 1 {
                                item.quantity = difference
                                item.push()
                            }
                        }.buttonStyle(BorderlessButtonStyle())
                        .font(.largeTitle)
                        Text("\(item.quantity)")
                            .font(.title)
                        Button("+"){
                            let sum = item.quantity + 1
                            item.quantity = sum
                            item.push()
                        }.buttonStyle(BorderlessButtonStyle())
                        .font(.largeTitle)
                    }
                    Button("Add to Cart") {
                        Order.currentOrder.add(item)
                    }.buttonStyle(BorderlessButtonStyle())
                }
                Spacer()
            }
            Text(item.shortDesc).bold().font(.callout)
            Spacer()
            Text(item.longDesc).italic().font(.callout)
            Spacer()
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
