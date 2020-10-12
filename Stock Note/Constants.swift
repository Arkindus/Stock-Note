//
//  Constants.swift
//  Stock Note
//
//  Created by Ankit Kumar on 09/10/20.
//

import Foundation

struct K {
    
    struct segue {
        static let stockSegue = "stockSegue"
        static let entrySegue = "entrySegue"
        static let reloadSegue = "reloadEntry"
    }
    
    struct cell {
        static let stockCell = "StockCell"
        static let entryCell = "EntryCell"
        static let archiveCell = "ArchiveCell"
    }
    
    struct SFormat {
        static let quantity = "Quantity: "
        static let rate = "Rate: "
    }
    
    struct realm {
        static let entries = "entries"
        static let dateCreated_D = "dateCreated_D"
        static let dateCreated_S = "dateCreated_S"
        static let dateUpdated = "dateUpdated"
        static let dateArchived = "dateArchived"
        static let profit = "arrow.up.circle"
        static let loss = "arrow.down.circle"
    }
}
