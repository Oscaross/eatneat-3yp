//
//  ReceiptParser.swift
//  EatNeat
//
//  Created by Oscar Horner on 17/12/2025.
//
// Pre-processes raw OCR data, removing redundant information and ordering it into related segments of the document ready for interpretation. Inspects lines to see if they can be fetched from the cache instead of an expensive LLM call.

import Foundation
import SwiftUI

struct ReceiptParser {
    var agent: AgentModel
    var context: AgentContext
    
    public func parse(lines: [OCRLine]) async throws {
        for line in lines {
            print("\(line.text)")
        }
        
        let trimmmedLines = preprocessLines(lines: lines) // pre-process lines to remove junk/token cost
        
        // generate task & parse lines
        let taskInstructions = MCPInstructions.generateItemsFromReceiptInstructions(lines: parseRemainingLines(lines: trimmmedLines))
        try await agent.triggerMCPTool(handler: RegisterNewItemHandler(), instructions: taskInstructions, context: context)
    }
    
    /// Trim irrelevant receipt data using regex-based pattern matching.
    private func preprocessLines(lines: [OCRLine]) -> [OCRLine] {
        // order lines by ascending y-axis position so that the top of the receipt is read first
        var lines = lines.sorted { $0.boundingBox.minY < $1.boundingBox.minY }
        
        // MARK: Pre-regex pattern matching
        
        // search for supermarket name in the document, if we see known supermarket names then we can infer the receipt came from there
        
        // a map of each known supermarket and the number of times it shows up in the receipt
        var supermarketMatches: [Supermarket : Int] = [:] // ie "Tesco" -> 4 means "Tesco" was found four times in receipt
        
        // for each line in the scan, check for supermarkets
        for line in lines {
            let text = line.text.lowercased()
            let candidateMatches = Supermarket.allCases
            
            // for each known supermarket, check if its present in the line
            for c in candidateMatches {
                let tokens = tokenize(from: line.text)

                for token in tokens {
                    if let market = Supermarket(rawValue: token) {
                        supermarketMatches[market, default: 0] += 1
                    }
                }
            }

        }
        
        var cameFrom = determineMatch(matches: supermarketMatches)
        
        guard cameFrom != nil else {
            return generalPatternMatch(lines: lines) // no supermarket detected so just general regex
        }
        
        // MARK: Normalisation
        
        // normalise text, fixing likely misreads from OCR and trimming unnecessary characters to make the regex process more effective
        
        
        
        // MARK: Regex pattern matching
        
        var regex = SupermarketRegex.getRegex(for: cameFrom!)
        
        // TODO: return generalPatternMatch(lines: lines)
        return lines
    }
    
    /// Filter redundant lines that are unlikely to contain product data.
    private func generalPatternMatch(lines : [OCRLine]) -> [OCRLine] {
        return []
    }
    
    /// Normalise lines to fix common OCR misreads and junk data.
    private func normalise(lines: [OCRLine]) -> [OCRLine] {
        return []
    }
    
    /// Determines whether a supermarket match can be made from the detected matches.
    private func determineMatch(matches : [Supermarket : Int]) -> Supermarket? {
        // case i. only one supermarket detected, just return that supermarket
        if matches.count == 1 {
            return matches.keys.first!
        }
        
        // case ii. multiple so pick one iff it exceeds the threshold
        let total = matches.values.reduce(0, +)
        guard total > 0 else { return nil }
        
        guard let (topMarket, topCount) = matches.max(by: { $0.value < $1.value }) else {
            return nil
        }
        
        let pTop = Double(topCount) / Double(total)

        let minCount = 2 // need more than 2 tokens matching the supermarket overall
        let threshold = 0.60 // over 60% of detected tokens should match the supermarket
        
        guard topCount >= minCount, pTop >= threshold else {
            return nil // case iii. no matches :(
        }
        
        return topMarket
    }
    
    /// Given pre-processed lines, normalises lines and then checks to see if they have been processed by MCP before in the caching database. Returns only lines that the system needs help to process.
    private func parseRemainingLines(lines: [OCRLine]) -> [OCRLine] {
        // TODO: Naive parser that just takes all lines and converts to text, can be optimised later
        return lines
    }
}

extension ReceiptParser {
    /// Tokenize a sentence, ie. "tesco whole milk" => ["tesco", "whole", "milk"]
    func tokenize(from text: String) -> [String] {
        text
            .lowercased()
            .split { !$0.isLetter }
            .map(String.init)
    }
}
