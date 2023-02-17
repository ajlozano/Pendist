//
//  Item.swift
//  Pendist
//
//  Created by Toni Lozano Fernández on 17/2/23.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") // property refers to declared in Category
}
