//
//  WanderingBarmanApp.swift
//  Shared
//
//  Created by Nick on 12/3/20.
//

import SwiftUI

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
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        readFromCache()
        NotificationCenter.default.addObserver(self, selector: #selector(onAppWillBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        return true
    }
    
    @objc func onAppWillBackground(){
        writeToCache()
    }
    
    let currentOrderKey = "current_order"
    let orderHistoryKey = "order_history"
    let accountKey = "account"
    let defaults = UserDefaults.standard
    
    func readFromCache(){
        if let orderData = defaults.object(forKey: currentOrderKey) as? Data,
           let order = try! NSKeyedUnarchiver.unarchivedObject(ofClass: Order.self, from: orderData) {
            Order.currentOrder = order
        }
        
        if let accountData = defaults.object(forKey: accountKey) as? Data,
           let account = try! NSKeyedUnarchiver.unarchivedObject(ofClass: Account.self, from: accountData){
            Account.current = account
        }
    }
    
    func writeToCache(){
        
        let orderData = try! NSKeyedArchiver.archivedData(withRootObject: Order.currentOrder, requiringSecureCoding: false)
        defaults.set(orderData, forKey: "current_order")
        
        let accountData = try! NSKeyedArchiver.archivedData(withRootObject: Account(), requiringSecureCoding: false)
        defaults.set(accountData, forKey: "account")
        
        defaults.synchronize()
    }
}


