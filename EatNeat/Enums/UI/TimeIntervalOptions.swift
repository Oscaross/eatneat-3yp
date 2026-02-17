//
//  TimeIntervalOptions.swift
//  EatNeat
//
//  Created by Oscar Horner on 14/02/2026.
//
// Allows users to work with custom time intervals when managing item filters

import Foundation

enum TimeUnit: String, CaseIterable, Identifiable {
    case days
    case weeks
    case months
    
    var id : Self {self}
    
    var secondsMultiplier: Int {
        switch self {
        case .days:   return 60 * 60 * 24
        case .weeks:  return 60 * 60 * 24 * 7
        case .months: return 60 * 60 * 24 * 30 // months are not always 30 days but this is good enough on the whole
        }
    }
}

extension TimeUnit {

    func displayName(for amount: Int) -> String {
        switch self {
        case .days:
            return amount == 1 ? "day" : "days"
        case .weeks:
            return amount == 1 ? "week" : "weeks"
        case .months:
            return amount == 1 ? "month" : "months"
        }
    }
}
