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

    var cartDelegate: Any?

    init(order: Order) {
        self.order = order
    }

    var body: some View {
        VStack {
            Text("Your Cart")
            List {
                ForEach(order.items, id: \.self) { orderItem in
                    OrderItemRow(orderItem)
                }
                .onDelete(perform: delete)
            }
            Button("Order \(order.totalString ?? "")") {
                presentMailCompose()
            }
            .padding(.bottom)
        }
    }

    func delete(at offsets: IndexSet) {
        order.items.remove(atOffsets: offsets)
        order.push()
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
        OrderView(order: Order.dummyOrder)
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
    private func presentMailCompose() {
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
