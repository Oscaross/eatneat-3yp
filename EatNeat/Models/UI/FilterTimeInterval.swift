//
//  FilterTimeInterval.swift
//  EatNeat
//
//  Created by Oscar Horner on 14/02/2026.
//
// A user friendly way of representing standard integer + TimeUnit times when they are filtering or describing time in the app

import Foundation

struct FilterTimeInterval : Equatable, Hashable {
    var amount: Int
    var unit: TimeUnit
    
    var asString: String {
        let unitString = unit.displayName(for: amount)
        return "\(amount) \(unitString)"
    }

    var timeInterval: TimeInterval {
        TimeInterval(amount * unit.secondsMultiplier)
    }
}
