//
//  PercentageCalculator.swift
//  Stock Note
//
//  Created by Ankit Kumar on 11/10/20.
//

import UIKit

struct PercentageCalculator {
    func percentage(from boughtRate: Double, to soldRate: Double) -> String {
        var increase: Double
        var decrease: Double
        var percent: Double
        if boughtRate <= soldRate {
            increase = soldRate - boughtRate
            percent = ((increase / boughtRate) * 100)
            return String(format: "%.0f", percent)
        } else {
            decrease = boughtRate - soldRate
            percent = ((decrease / boughtRate) * 100)
            return String(format: "%.0f", percent)
        }
       
    }
    
    func percentageColor(from boughtRate: Double, to soldRate: Double) -> Bool {
        if boughtRate <= soldRate {
            return true
        } else {
            return false
        }
    }
}
