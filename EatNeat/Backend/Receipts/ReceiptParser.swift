//
//  ReceiptParser.swift
//  EatNeat
//
//  Created by Oscar Horner on 17/12/2025.
//
// Pre-processes raw OCR data, removing redundant information and ordering it into related segments of the document ready for interpretation.

import Foundation

struct ReceiptParser {
    
    public func parse(lines: [OCRLine]) {
        for line in lines {
            print("\(line.text) - \(line.boundingBox)")
        }
        
        let data = preprocessLines(lines: lines)
    }
    
    /// Trim irrelevant receipt data using regex-based pattern matching.
    private func preprocessLines(lines: [OCRLine]) -> [OCRLine] {
        // TODO: Need to find common receipt patterns to filter out headers, footers, totals, dates, etc.
        return []
    }
    
    private func parseRemainingLines(lines: [OCRLine]) -> [OCRLine] {
        return []
    }
    
}
