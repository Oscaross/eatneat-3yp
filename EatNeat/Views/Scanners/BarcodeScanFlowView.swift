//
//  BarcodeScanFlowView.swift
//  EatNeat
//
//  Created by Oscar Horner on 07/02/2026.
//
// Uses the ScanFlow abstraction to build the barcode scanner flow

//import SwiftUI
//
//struct BarcodeScanFlowView: View {
//    var body: some View {
//        ScanFlowView(
//            title: "Barcode Scanner",
//            description: "Scan a product barcode to add a single item.",
//            icon: "barcode.viewfinder",
//            instructions: [
//                "Ensure the barcode is clearly visible.",
//                "Hold the phone steady.",
//                "Avoid glare or reflections."
//            ],
//            skipPreferenceKey: "pref.scanning.skipBarcodeLanding"
//        ) { isProcessing, onComplete in
//            EmptyView()
//        }
//    }
//
//    @EnvironmentObject var pantryVM: PantryViewModel
//}
