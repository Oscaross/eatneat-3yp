//
//  OCRLine.swift
//  EatNeat
//
//  Created by Oscar Horner on 25/01/2026.
//

import Foundation
import CoreGraphics

struct OCRLine: Identifiable {
    let id = UUID()
    let text: String
    let boundingBox: CGRect
    let confidence: Float
}
