//
//  ReceiptParser.swift
//  EatNeat
//
//  Created by Oscar Horner on 17/12/2025.
//
// Pre-processes raw OCR data, removing redundant information and ordering it into related segments of the document ready for interpretation.

import Foundation
import SwiftUI

struct ReceiptParser {
    var agent: AgentModel
    var context: AgentContext
    
    public func parse(lines: [OCRLine]) async throws {
        for line in lines {
            print("\(line.text) - \(line.boundingBox)")
        }
        
        let trimmmedLines = preprocessLines(lines: lines) // pre-process lines to remove junk/token cost
        
        // generate task & parse lines
        var taskInstructions = MCPInstructions.generateItemsFromReceiptInstructions(lines: parseRemainingLines(lines: trimmmedLines))
        try await agent.triggerMCPTool(handler: RegisterNewItemHandler(), instructions: taskInstructions, context: context)
    }
    
    /// Trim irrelevant receipt data using regex-based pattern matching.
    private func preprocessLines(lines: [OCRLine]) -> [OCRLine] {
        // TODO: Need to find common receipt patterns to filter out headers, footers, totals, dates, etc. Regex matching?
        return lines
    }
    
    private func parseRemainingLines(lines: [OCRLine]) -> [OCRLine] {
        // TODO: Naive parser that just takes all lines and converts to text, can be optimised later
        return lines
    }
    
}
