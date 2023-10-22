//
//  Item.swift
//  Todoey
//
//  Created by Haldox on 22/10/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    /* Dynamic is a declaration modifier. It tells the compiler to use a dynamic dispatch as opposed to the standard
     static dispatch. This allows the property 'title' or 'done' to be monitored for change at runtime */
    // Declared as dynamic so that Realm can monitor the changes in the variable at runtime and update
    // @objc tag means this behaviour comes from the Objective-C API
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    
    // Create the inverse relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
