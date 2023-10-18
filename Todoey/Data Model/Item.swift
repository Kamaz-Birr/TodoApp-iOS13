//
//  Item.swift
//  Todoey
//
//  Created by Haldox on 18/10/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

// Codable shows the class conforms to both Encodable, Decodable protocols
class Item: Codable {
    var title: String = ""
    var done: Bool = false
}
