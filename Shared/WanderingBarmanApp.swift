//
//  WanderingBarmanApp.swift
//  Shared
//
//  Created by Nick on 12/3/20.
//

import SwiftUI
import UIKit

let encoder = JSONEncoder()
let decoder = JSONDecoder()

@main
struct WanderingBarmanApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        configureAppearance()
        readFromCache()
        NotificationCenter.default.addObserver(self, selector: #selector(onAppWillBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        return true
    }
    
    func configureAppearance(){
//        UITableView.appearance().backgroundColor = UIColor.green
        UITableViewCell.appearance().selectedBackgroundView = UIView() //kill selection color
        UICollectionViewCell.appearance().selectedBackgroundView = UIView()
    }

    @objc func onAppWillBackground() {
        writeToCache()
    }

    let currentOrderKey = "current_order"
    let orderHistoryKey = "order_history"
    let accountKey = "account"
    let defaults = UserDefaults.standard

    func readFromCache() {
        if let orderData = defaults.object(forKey: "current_order") as? Data,
           let order = try? decoder.decode(Order.self, from: orderData) {
            Order.currentOrder = order
            print("decoded order:\n\(String(describing: Order.currentOrder))")
        }

        if let accountData = defaults.object(forKey: "account") as? Data,
           let account = try? decoder.decode(Account.self, from: accountData) {
            Account.current = account
            print("decoded account:\n\(String(describing: account))")
        }
    }

    func writeToCache() {
        if let encoded = try? encoder.encode(Order.currentOrder) {
            defaults.set(encoded, forKey: "current_order")
        }

        if let encoded = try? encoder.encode(Account()) {
            defaults.set(encoded, forKey: "account")
        }

        defaults.synchronize()
    }
}
