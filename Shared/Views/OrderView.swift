//
//  CartView.swift
//  WanderingBarman (iOS)
//
//  Created by Nick on 12/3/20.
//

import SwiftUI
import MessageUI

struct OrderView: View {

    private let mailComposeDelegate = MailComposerDelegate()
    private let messageComposeDelegate = MessageComposerDelegate()

    @ObservedObject var order: Order
    @Binding var tabSelection: Int

    var cartDelegate: Any?

    var body: some View {
        NavigationView {
            VStack {
                Section(header: Text("Your Cart"), footer: OrderFooter(tabSelection: $tabSelection, parentView: self)) {
                    List {
                        ForEach(order.items, id: \.self) { orderItem in
                            NavigationLink(
                                destination: DetailView(item: orderItem.menuItem),
                                label: {
                                    OrderItemRow(orderItem)
                                })
                        }
                        .onDelete(perform: delete)
                        .listRowBackground(Color.black)
                    }.listStyle(PlainListStyle())
                }
            }
        }.navigationBarHidden(true)
    }

    func delete(at offsets: IndexSet) {
        order.items.remove(atOffsets: offsets)
        order.push()
    }
}

struct OrderFooter: View {
    @Binding var tabSelection: Int
    let parentView: OrderView
    
    var body: some View {
        VStack {
            Button(action: {
                $tabSelection.wrappedValue = 1
            }) {
                HStack {
                    Image(systemName: "arrowshape.turn.up.left")
                    Text("Continue Shopping")
                }
            }
            Spacer()
                .frame(height: 40.0)
            Button("Order \(parentView.order.totalString ?? "")") {
                parentView.presentMailCompose()
            }.font(.title)
            Spacer()
                .frame(height: 20.0)
        }
    }
}

struct OrderItemRow: View {
    @ObservedObject var item: OrderItem
    
    init(_ item: OrderItem) {
        self.item = item
    }
    
    let rowHeight:CGFloat = 100
    
    var body: some View {
        let pad:CGFloat = 20
        VStack {
            HStack {
                Text("\(item.quantity) x \(item.menuItem.title)")
                Spacer()
                Text("\(item.priceString!)")
            }.font(.body)
            HStack {
                Spacer()
                    .frame(width: pad)
                Text("\(item.menuItem.shortDesc)")
                Spacer()
                Text("ea \(item.menuItem.priceString!)")
                    .padding(.trailing, pad)
                
            }.font(.caption)
            .foregroundColor(.gray)
        }
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        OrderView(order: Order.dummyOrder, tabSelection: .constant(1))
    }
}

extension OrderView {

    private class MailComposerDelegate: NSObject, MFMailComposeViewControllerDelegate {
        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {

            controller.dismiss(animated: true)
        }
    }
    /// Present an mail compose view controller modally in UIKit environment
    func presentMailCompose() {
        guard MFMailComposeViewController.canSendMail() else {
            return
        }
        let vc = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = mailComposeDelegate
        composeVC.setMessageBody(order.orderText, isHTML: false)
        composeVC.setToRecipients(["orders@wanderingbarman.com"])
        composeVC.setSubject("FOXHOLE Order \(order.id)")

        vc?.present(composeVC, animated: true)
    }
}

// MARK: The message extension

extension OrderView {

    private class MessageComposerDelegate: NSObject, MFMessageComposeViewControllerDelegate {
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            // Customize here
            controller.dismiss(animated: true)
        }
    }
    /// Present an message compose view controller modally in UIKit environment
    private func presentMessageCompose() {
        guard MFMessageComposeViewController.canSendText() else {
            return
        }
        let vc = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = messageComposeDelegate
        composeVC.body = order.orderText

        vc?.present(composeVC, animated: true)
    }
}
