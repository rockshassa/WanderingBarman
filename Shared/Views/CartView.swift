//
//  CartView.swift
//  WanderingBarman (iOS)
//
//  Created by Nick on 12/3/20.
//

import SwiftUI
import MessageUI

struct CartView: View {

    private let mailComposeDelegate = MailComposerDelegate()
    private let messageComposeDelegate = MessageComposerDelegate()

    @ObservedObject var order:Order
    
    var cartDelegate:Any?
    
    init(order:Order) {
        self.order = order
    }
    
    var body: some View {
        VStack {
            Text("Your Cart")
            List {
                ForEach(order.items, id: \.self) { orderItem in
                    CartItemRow(orderItem.menuItem)
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

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView(order: Order.dummyOrder)
    }
}

extension CartView {

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

extension CartView {

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
