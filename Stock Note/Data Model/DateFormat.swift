//
//  DateModel.swift
//  Stock Note
//
//  Created by Ankit Kumar on 10/10/20.
//

import UIKit

struct DateFormat {
    func saveFormat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss a"
        return dateFormatter.string(from: date)
    }
    
    func entryDate_SFormat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
    
    func loadFormat(date: String) -> String {
        return String(date.prefix(10))
    }
}
