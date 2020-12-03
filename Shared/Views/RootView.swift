//
//  RootView.swift
//  WanderingBarman (iOS)
//
//  Created by Nick on 12/3/20.
//

import SwiftUI

struct RootTabView: View {
    
    @ObservedObject var order:Order
    
    init(_ order:Order) {
        self.order = order
    }
    
    private var badgePosition: CGFloat = 2
    private var tabsCount: CGFloat = 2
    
    var body: some View {
            GeometryReader { geometry in
                ZStack(alignment: .bottomLeading) {
                // TabView
                TabView {
                    MenuView().tabItem {
                        Image(systemName: "list.dash")
                        Text("Menu")
                    }.tag(0)
                    CartView(order:Order.currentOrder).tabItem {
                        Image(systemName: "cart.fill")
                        Text("Cart")
                    }
                }

                // Badge View
                ZStack {
                  Circle()
                    .foregroundColor(.red)

                    Text("\(Order.currentOrder.items.count)")
                    .foregroundColor(.white)
                    .font(Font.system(size: 12))
                }
                .frame(width: 15, height: 15)
                .offset(x: ( ( 2 * self.badgePosition) - 0.95 ) * ( geometry.size.width / ( 2 * self.tabsCount ) ) + 2, y: -30)
              }
            }
        }
}

struct RootView: View {
    @State var splashDismissed = true//false
    
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
