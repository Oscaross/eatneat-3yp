//
//  ScannerError.swift
//  EatNeat
//
//  Created by Oscar Horner on 11/02/2026.
//
// Represents the scanning errors that can happen with barcode scanning

enum ScannerError: Error {
    case notFound
    case noInternet
    case generic
}

extension ScannerError {
    func getDescription() -> String {
        switch self {
        case .notFound:
            return "The product was not found in our databases."
        case .noInternet:
            return "No/inadequate Internet connection."
        case .generic:
            return "An unexpected error occurred, contact the developer directly."
        }
    }
    
    func getSolutions() -> [String] {
        switch self {
        case .notFound:
            return [
                "Refer to the scanner guidelines for how to scan a product effectively.",
                "Add the product manually."
            ]
        case .noInternet:
            return [
                "Ensure you are connected to the Internet and that your connection is stable."
            ]
            
        case .generic:
            return []
        }
    }
}
