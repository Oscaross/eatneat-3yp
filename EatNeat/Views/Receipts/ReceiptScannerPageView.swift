//
//  ReceiptScannerPageView.swift
//  EatNeat
//
//  Created by Oscar Horner on 17/12/2025.
//

import SwiftUI

struct ReceiptScannerPageView: View {
    @ObservedObject var viewModel: PantryViewModel

    @State private var showScanner = false
    @State private var ocrLines: [OCRLine] = []

    var body: some View {
        VStack {
            Button("Scan Receipt") {
                showScanner = true
            }
            
            AfterScanView(scanned: viewModel.getAllItems(), vm: viewModel)
        }
        .sheet(isPresented: $showScanner) {
            ReceiptScannerView { lines in
                ocrLines = lines
            }
        }
    }
}
