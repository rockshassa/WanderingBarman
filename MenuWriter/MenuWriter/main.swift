//
//  main.swift
//  MenuWriter
//
//  Created by Nicholas Galasso on 1/20/21.
//

import Foundation

let encoder = JSONEncoder()
let decoder = JSONDecoder()

let menu:Menu = {
    var m = Menu()
    m.items = [MenuItem()]
    return m
}()

func writeMenu(){
    let jsonData = try! JSONEncoder().encode(menu)
    let jsonString = String(data: jsonData, encoding: .utf8)!
    
    let file = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("menu.json")
//    let file = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("menu-\(Date()).json")
    
    try! jsonString.write(to: file,
                         atomically: true,
                         encoding: .utf8)
}

writeMenu()
