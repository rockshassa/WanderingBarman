//
//  Account.swift
//  WanderingBarman (iOS)
//
//  Created by Nick on 12/4/20.
//

import Foundation

class Account: NSObject, NSSecureCoding, ObservableObject {
    static var supportsSecureCoding: Bool = true
    
    override init() {       
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(firstName, forKey: "firstName")
        coder.encode(lastName, forKey: "lastName")
        coder.encode(phone, forKey: "phone")
        coder.encode(addressStreet, forKey: "addressStreet")
        coder.encode(addressStreet2, forKey: "addressStreet2")
        coder.encode(addressCity, forKey: "addressCity")
        coder.encode(addressState, forKey: "addressState")
        coder.encode(addressZip, forKey: "addressZip")
    }
    
    required init?(coder: NSCoder) {
        firstName = coder.decodeObject(forKey: "firstName") as! String
        lastName = coder.decodeObject(forKey: "lastName") as! String
        phone = coder.decodeObject(forKey: "phone") as! String
        addressStreet = coder.decodeObject(forKey: "addressStreet") as! String
        addressStreet2 = coder.decodeObject(forKey: "addressStreet2") as! String
        addressCity = coder.decodeObject(forKey: "addressCity") as! String
        addressState = coder.decodeObject(forKey: "addressState") as! String
        addressZip = coder.decodeObject(forKey: "addressZip") as! String
    }
    
    static var current:Account = Account()
    
    var firstName = "Nick"
    var lastName = "Galasso"
    var phone = "+16092801871"
    var addressStreet = "114 Troutman St"
    var addressStreet2 = "520"
    var addressCity = "Brooklyn"
    var addressState = "NY"
    var addressZip = "11206"
    
    var fullName:String {
        return "\(firstName) \(lastName)"
    }
}
