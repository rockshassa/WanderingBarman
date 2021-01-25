//
//  main.swift
//  MenuWriter
//
//  Created by Nicholas Galasso on 1/20/21.
//

import Foundation

let encoder = JSONEncoder()
let decoder = JSONDecoder()

func writeMenu() {
    encoder.outputFormatting = .prettyPrinted
    var menu = Menu()
    menu.date = Date()
    menu.items = Menu.allItems
    let jsonData = try! encoder.encode(menu)
    let jsonString = String(data: jsonData, encoding: .utf8)!

    let file = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("menu.json")
//    let file = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("menu-\(Date()).json")

    try! jsonString.write(to: file,
                         atomically: true,
                         encoding: .utf8)
}

writeMenu()
