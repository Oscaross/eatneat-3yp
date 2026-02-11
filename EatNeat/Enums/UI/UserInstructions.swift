//
//  UserInstructions.swift
//  EatNeat
//
//  Created by Oscar Horner on 09/02/2026.
//
// Hardcodes data relating to user instructions for various features of the app such as receipt scanning

enum UserInstructions {
    /// Instructions for users to correctly scan receipts, shown on the landing page and also in the event of an error occuring.
    static func receiptInstructions() -> [String] {
        [
            "Ensure the scan is done in a well-lit area or the torch is used.",
            "Ensure the document is fully scanned facing downwards and the camera is stable.",
            "You must have an adequate Internet connection.",
            "Ensure the receipt is as flat and uncrumpled as possible.",
            "Damage or weathering to the receipt will impact scan performance."
        ]
    }
    
    /// Instructions for users to correctly scan barcodes, shown on the landing page and also in the event of an error occuring.
    static func barcodeInstructions() -> [String] {
        [
            "Ensure the scan is done in a well-lit area or the torch is used.",
            "Ensure the barcode is fully visible, flat and the camera is stable.",
            "You must have an adequate Internet connection.",
            "Damage or weathering to the barcode will impact scan performance."
        ]
    }
}

