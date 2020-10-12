//
//  Archive.swift
//  Stock Note
//
//  Created by Ankit Kumar on 10/10/20.
//

import Foundation
import RealmSwift

class Archive: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var quantityArchived: Double = 0.0
    @objc dynamic var rateArchived: Double = 0.0
    @objc dynamic var percentageArchived: String = ""
    @objc dynamic var colorProfitOrLoss: Bool = false
    @objc dynamic var dateArchived: String?
}
