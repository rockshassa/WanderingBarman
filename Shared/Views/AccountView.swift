//
//  AccountView.swift
//  WanderingBarman (iOS)
//
//  Created by Nick on 12/4/20.
//

import SwiftUI

struct AccountView: View {

    @ObservedObject var account: Account

    init(_ account: Account) {
        self.account = account
    }

    var body: some View {

        GeometryReader { geometry in
            let width = geometry.size.width * 0.4
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Image(systemName: "person.fill").resizable()
                        .frame(width: width, height: width)
                    Divider()
                    Text(account.fullName)
                    Text("\(account.addressStreet) \(account.addressStreet2)")
                    Text("\(account.addressCity), \(account.addressState) \(account.addressZip)")
                    Text(account.phone)
                    Divider()
                    Text("Past Orders").multilineTextAlignment(.leading)
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(Account())
    }
}
