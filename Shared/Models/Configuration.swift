//
//  Configuration.swift
//  MenuWriter
//
//  Created by Nicholas Galasso on 1/25/21.
//

import Foundation

struct Configuration: Codable {
    var menu: Menu
    var hours: String
    var deliveryDistanceMeters: Int
}
