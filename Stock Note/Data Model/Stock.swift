//
//  Stock.swift
//  Stock Note
//
//  Created by Ankit Kumar on 09/10/20.
//

import Foundation
import RealmSwift

class Stock: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var totalQuantity: Double = 0.0
    @objc dynamic var totalRate: Double = 0.0
    @objc dynamic var dateUpdated: String?
    
    let entries = List<Entry>()
}
