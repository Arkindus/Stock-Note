//
//  TotalRateCalculator.swift
//  Stock Note
//
//  Created by Ankit Kumar on 10/10/20.
//

import UIKit

struct TotalRateCalulator {
    func totalRate(_ individualRate: Double, _ quantity: Double) -> Double{
        return (individualRate * quantity)
    }
}
