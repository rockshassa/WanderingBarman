//
//  Account.swift
//  WanderingBarman (iOS)
//
//  Created by Nick on 12/4/20.
//

import Foundation

extension CustomStringConvertible where Self: Codable {
    var description: String {
        if let encoded = try? encoder.encode(self) {
            return String(decoding: encoded, as: UTF8.self)
        }
        return "unable to describe \(self)"
    }
}

class Account: UIObservable, Codable, CustomStringConvertible {

    override init() {
        super.init()
    }

    static var current: Account = Account()

    var firstName = "Nick"
    var lastName = "Galasso"
    var phone = "+16092801871"
    var addressStreet = "114 Troutman St"
    var addressStreet2 = "520"
    var addressCity = "Brooklyn"
    var addressState = "NY"
    var addressZip = "11206"

    var fullName: String {
        return "\(firstName) \(lastName)"
    }
}
