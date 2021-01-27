//
//  RootView.swift
//  WanderingBarman (iOS)
//
//  Created by Nick on 12/3/20.
//

import SwiftUI

struct RootTabView: View {

    @ObservedObject var order: Order

    init(_ order: Order) {
        self.order = order
    }

    private var badgePosition: CGFloat = 2
    private var tabsCount: CGFloat = 3
    @State var tabSelection = 1

    var body: some View {
            GeometryReader { geometry in
                ZStack(alignment: .bottomLeading) {
                TabView(selection: $tabSelection) {
                    MenuView().tabItem {
                        Image(systemName: "list.dash")
                        Text("Menu")
                    }.tag(1)
                    OrderView(order: Order.currentOrder, tabSelection: $tabSelection).tabItem {
                        Image(systemName: "cart.fill")
                        Text("Cart")
                    }.tag(2)
                    AccountView(Account.current).tabItem {
                        Image(systemName: "person.fill")
                        Text("Account")
                    }.tag(3)
                }

                let itemCount = order.quantityForBadge

                // Badge View
                ZStack {
                  Circle()
                    .foregroundColor(.red)

                    Text("\(itemCount)")
                    .foregroundColor(.white)
                    .font(Font.system(size: 12))
                }
                .opacity(itemCount > 0 ? 1 : 0)
                .frame(width: 15, height: 15)
                .offset(x: ( ( 2 * self.badgePosition) - 0.95 ) * ( geometry.size.width / ( 2 * self.tabsCount ) ) + 2, y: -30)
              }
            }
        }
}

struct RootView: View {
    @State var splashDismissed = false

    var body: some View {
        if !splashDismissed {
            SplashView(self)
        } else {
            RootTabView(Order.currentOrder)
        }
    }
}

struct RootTabView_Previews: PreviewProvider {
    static var previews: some View {
        RootTabView(Order.dummyOrder)
    }
}
