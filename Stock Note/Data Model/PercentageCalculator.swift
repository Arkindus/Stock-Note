//
//  PercentageCalculator.swift
//  Stock Note
//
//  Created by Ankit Kumar on 11/10/20.
//

import UIKit

struct PercentageCalculator {
    func percentage(from boughtRate: Double, to soldRate: Double) -> String {
        var percentage: Double
        if boughtRate <= soldRate {
            percentage = ((boughtRate / soldRate) * 100)
        } else {
            percentage = ((soldRate / boughtRate) * 100)
        }
        return String(format: "%.2f", percentage)
    }
    
    func percentageColor(from boughtRate: Double, to soldRate: Double) -> Bool {
        if boughtRate <= soldRate {
            return true
        } else {
            return false
        }
    }
}
