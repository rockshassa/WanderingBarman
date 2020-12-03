//
//  CartView.swift
//  WanderingBarman (iOS)
//
//  Created by Nick on 12/3/20.
//

import SwiftUI

struct CartView: View {
    
    @State var order = Order.currentOrder
    
    var body: some View {
        HStack {
            Text("Your Cart")
            List(order.items) { orderItem in
                ItemRow(orderItem.item)
            }
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
    }
}
