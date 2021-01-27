//
//  DetailView.swift
//  WanderingBarman (iOS)
//
//  Created by Nicholas Galasso on 1/27/21.
//

import SwiftUI

enum CartUpdateMode {
    case addToCart, updateCart
}

struct AddToCartPicker: View {
    @ObservedObject var item:MenuItem
    @State var quantity:Int
    
    var initialQuantity:Int {
        switch cartUpdateMode {
        case .updateCart:
            return Order.currentOrder.quantity(item)
        case .addToCart:
            return 1
        }
    }
    
    var cartUpdateMode:CartUpdateMode {
        if Order.currentOrder.contains(item){
            return .updateCart
        }
        return .addToCart
    }
    
    var buttonText:String {
        switch cartUpdateMode {
        case .addToCart:
            return "Add to Cart"
        case .updateCart:
            return "Update Cart"
        }
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
        
    var body: some View {
        HStack(alignment: .center, spacing: 40.0) {
            HStack(alignment: .center, spacing: 20.0) {
                Button("-"){
                    let difference = quantity - 1
                    switch cartUpdateMode {
                    case .addToCart:
                        if difference >= 1 {
                            quantity = difference
                        }
                    case .updateCart:
                        if difference >= 0 {
                            quantity = difference
                        }
                    }
                    
                }.buttonStyle(BorderlessButtonStyle())
                .font(.largeTitle)
                Text("\($quantity.wrappedValue)")
                    .font(.title)
                Button("+"){
                    let sum = quantity + 1
                    quantity = sum
                    
                }.buttonStyle(BorderlessButtonStyle())
                .font(.largeTitle)
            }
            Button(buttonText) {
                switch cartUpdateMode {
                case .addToCart:
                    Order.currentOrder.add(item, quantity: quantity)
                case .updateCart:
                    Order.currentOrder.update(item, quantity: quantity)
                }
                self.presentationMode.wrappedValue.dismiss() //go back programmatically
                
            }.buttonStyle(BorderlessButtonStyle())
        }
    }
}

struct DetailView: View {
    
    @ObservedObject var item:MenuItem
    
    var body: some View {
        VStack(alignment: .center) {
            Image("\(item.imageName)").resizable().aspectRatio(contentMode: .fit).padding(.top, -200.0)
            HStack {
                Spacer()
                Text(item.title).bold().font(.title)
                Spacer()
                VStack {
                    Text("\(item.priceString!)")
                    Text("\(item.size) / \(item.abv)% abv").font(.caption)
                }
                Spacer()
            }
            Spacer()
            Text(item.longDesc).italic().font(.callout)
            AddToCartPicker(item:item, quantity: Order.currentOrder.quantity(item))
            Spacer()
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(item: Menu.allItems.last!)
    }
}
