//
//  Category.swift
//  Todoey
//
//  Created by Haldox on 22/10/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var bgColour: String = ""
    
    // Create relationships between the data models
    // 1. The forward relationship (Category >> Item) ie in every category there is a property that points to a list of Item objects
    // 2. You create the inverse relationship (Item >> Category) in the Item class
    // The forward relationship is a one-to-many relationship type
    let items = List<Item>()
}
