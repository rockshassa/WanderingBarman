//
//  Menu.swift
//  WanderingBarman
//
//  Created by Nick on 12/3/20.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        NavigationView{
            VStack {
                Section(header: MenuSectionHeader()) {
                    List {
                        //use ForEach inside list to access BG color
                        ForEach(Menu.allItems) { item in
                            NavigationLink(
                                destination: DetailView(item: item),
                                label: {
                                    MenuItemRow(item)
                                })
                        }.listRowBackground(Color.black)
                    }
                }
            }.navigationBarHidden(true)
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
        HStack {
            Image(item.imageName).resizable().aspectRatio(contentMode: .fit).frame(height: 120.0)
            Spacer()
            VStack(alignment: .center) {
                Spacer()
                Text(item.title).bold().font(.headline)
                Spacer()
                Text(item.shortDesc).bold().font(.subheadline)
                Spacer()
            }
            Spacer()
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
