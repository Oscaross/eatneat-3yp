//
//  BarcodeScanner.swift
//  EatNeat
//
//  Created by Oscar Horner on 09/02/2026.
//
// Parses a scanned barcode and registers it as a new item.

import Foundation

final class BarcodeScanner {
    var agent: AgentModel
    var context: AgentContext
    
    init(agent: AgentModel, context: AgentContext) {
        self.agent = agent
        self.context = context
    }
    
    /// Loads the instance of the product into AgentContext for a given barcode in any format.
    public func scan(barcode: String) async throws {
        print("Successfully scanned and received barcode! " + barcode)
        
        guard let product = try await fetchProduct(barcode: barcode) else {
            throw ScannerError.notFound  // no product was found so no item is registered
        }
        
        // now we have the JSON from the standard database we need to convert into our own local PantryItem instance and store in AgentContext
        try await agent.triggerMCPTool(
            handler: RegisterNewItemHandler(),
            instructions: MCPInstructions.generateItemFromBarcodeInstructions(data: product),
            context: context
        )
        
    }
    
    /// Searches the OFF database and decodes the JSON response from the API.
    func fetchProduct(barcode: String) async throws -> OFFProduct? {
        let urlString = "https://world.openfoodfacts.org/api/v0/product/\(barcode).json"
        guard let url = URL(string: urlString) else { return nil }

        let (data, _) = try await URLSession.shared.data(from: url)

        let decoded = try JSONDecoder().decode(OFFResponse.self, from: data)
        return decoded.product
    }
}
