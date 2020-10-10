//
//  DateModel.swift
//  Stock Note
//
//  Created by Ankit Kumar on 10/10/20.
//

import UIKit

struct DateModel {
    func dateFormat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: date)
    }
}
