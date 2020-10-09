//
//  Entry.swift
//  Stock Note
//
//  Created by Ankit Kumar on 09/10/20.
//

import Foundation
import RealmSwift

class Entry: Object {
    @objc dynamic var quantity: Double = 0.0
    @objc dynamic var individualRate: Double = 0.0
    @objc dynamic var totalRate: Double = 0.0
    @objc dynamic var used: Bool = false
    @objc dynamic var dateCreated: Date?
}
