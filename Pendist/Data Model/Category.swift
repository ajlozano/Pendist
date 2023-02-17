//
//  Category.swift
//  Pendist
//
//  Created by Toni Lozano Fernández on 17/2/23.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
