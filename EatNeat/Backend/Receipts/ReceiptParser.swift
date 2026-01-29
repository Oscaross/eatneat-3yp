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
        
        let trimmedLines = preprocessLines(lines: lines) // pre-process lines to remove junk/token cost
        
        // generate task & parse lines
        let taskInstructions = MCPInstructions.generateItemsFromReceiptInstructions(lines: trimmedLines)
        try await agent.triggerMCPTool(handler: RegisterNewItemHandler(), instructions: taskInstructions, context: context)
    }
    
    /// Trim irrelevant receipt data using regex-based pattern matching.
    private func preprocessLines(lines: [OCRLine]) -> [String] {
        let grouped = groupLinesTogether(lines: lines)
        // MARK: Pre-normalise text before regex
        

        
        // MARK: Regex-based trimming, remove all lines that seem to be junk or heavily malformed
        
        // search for supermarket name in the document, if we see known supermarket names then we can infer the receipt came from there
        
        // a map of each known supermarket and the number of times it shows up in the receipt
        var supermarketMatches: [Supermarket : Int] = [:] // ie "Tesco" -> 4 means "Tesco" was found four times in receipt
        
        for line in lines {
            let tokens = tokenize(from: line.text.lowercased())

            for supermarket in Supermarket.allCases {
                let name = supermarket.rawValue.lowercased()

                if tokens.contains(name) {
                    supermarketMatches[supermarket, default: 0] += 1
                }
            }
        }
        
        var regex = ReceiptRegex.rules(for: determineMatch(matches: supermarketMatches)) // get our tailored regex for filtering this receipt
        
        let cleanedLines = applyRegexRules(
            to: grouped,
            using: regex
        )
        
        // MARK: Post-regex normalisation
        
        // normalise text, fixing likely misreads from OCR and trimming unnecessary characters to make the regex process more effective
        
        // MARK: OCRLine hashing and checking cache for duplicates
        
        return cleanedLines
    }
    
    /// Groups lines that are close together vertically into single strings.
    private func groupLinesTogether(lines: [OCRLine]) -> [String] {
        guard !lines.isEmpty else { return [] }

        let sorted = lines.sorted {
            $0.boundingBox.maxY > $1.boundingBox.maxY
        }

        let tolerance = medianHeight(of: sorted) * 0.6 // how close lines need to be vertically to be grouped

        var groups: [[OCRLine]] = []

        for line in sorted {
            let midY = line.boundingBox.midY

            if let lastGroup = groups.last,
               abs(midY - lastGroup[0].boundingBox.midY) <= tolerance {
                groups[groups.count - 1].append(line)
            } else {
                groups.append([line])
            }
        }

        // Merge text within each group
        return groups.map { group in
            group
                .sorted { $0.boundingBox.minX < $1.boundingBox.minX }
                .map { $0.text.trimmingCharacters(in: .whitespacesAndNewlines) }
                .joined(separator: " ")
        }
    }

    /// Computes median line height a set of OCR lines
    func medianHeight(of lines: [OCRLine]) -> CGFloat {
        let heights = lines
            .map { $0.boundingBox.height }
            .sorted()

        guard !heights.isEmpty else { return 0 }

        let mid = heights.count / 2

        if heights.count % 2 == 0 {
            return (heights[mid - 1] + heights[mid]) / 2
        } else {
            return heights[mid]
        }
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
}

extension ReceiptParser {
    /// Tokenize a sentence, ie. "tesco whole milk" => ["tesco", "whole", "milk"]
    func tokenize(from text: String) -> [String] {
        text
            .lowercased()
            .split { !$0.isLetter }
            .map(String.init)
    }
    
    /// Applies regex-based rules to filter OCR lines.
    func applyRegexRules(
        to lines: [String],
        using rules: ReceiptRules
    ) -> [String] {

        var result: [String] = []

        for line in lines {

            // stopping rules, parsing halts here
            if rules.stopAfter.contains(where: { $0.matches(line) }) {
                break
            }

            // removal via blacklist
            if rules.blacklist.contains(where: { $0.matches(line) }) {
                continue
            }

            // keep line if it got this far
            result.append(line)
        }

        return result
        
    }
}

extension NSRegularExpression {
    func matches(_ text: String) -> Bool {
        firstMatch(
            in: text,
            options: [],
            range: NSRange(text.startIndex..., in: text)
        ) != nil
    }
}
