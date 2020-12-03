//
//  CartView.swift
//  WanderingBarman (iOS)
//
//  Created by Nick on 12/3/20.
//

import SwiftUI

struct CartItemRow: View {
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
                Text("\(item.title)")
                    .font(.callout)
                Text("\(item.priceString!) x \(item.orderQty)")
            }
        }
    }
}

struct CartView: View {
    
    @ObservedObject var order:Order
    
    var cartDelegate:Any?
    
    init(order:Order) {
        self.order = order
    }
    
    var body: some View {
        VStack {
            Text("Your Cart")
            List(order.items) { orderItem in
                CartItemRow(orderItem)
            }
            Button("Order \(order.totalString ?? "")") {
                
            }
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView(order: Order.dummyOrder)
    }
}
