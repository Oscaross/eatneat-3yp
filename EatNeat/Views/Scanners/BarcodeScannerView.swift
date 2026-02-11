//
//  BarcodeScannerView.swift
//  EatNeat
//
//  Created by Oscar Horner on 09/02/2026.
//
// Responsible for scanning barcodes using the VisionKit framework, sending the scanned barcode into the backend to be mapped to an item instance.

import SwiftUI
import VisionKit

struct BarcodeScannerView: UIViewControllerRepresentable {
    /// Called with the scanned barcode payload (e.g., EAN/UPC as string).
    let onScan: (String) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onScan: onScan)
    }

    func makeUIViewController(context: Context) -> DataScannerViewController {
        // does the device support scanning?
        guard DataScannerViewController.isSupported else {
            return DataScannerViewController()
        }

        let vc = DataScannerViewController(
            recognizedDataTypes: [.barcode()],
            qualityLevel: .balanced,
            recognizesMultipleItems: false,
            isHighFrameRateTrackingEnabled: true,
            isPinchToZoomEnabled: true
        )

        vc.delegate = context.coordinator
        context.coordinator.scanner = vc
        return vc
    }

    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        // Start scanning once the controller is on-screen and available.
        context.coordinator.startIfNeeded()
    }

    static func dismantleUIViewController(_ uiViewController: DataScannerViewController, coordinator: Coordinator) {
        coordinator.stopIfNeeded()
        coordinator.scanner = nil
    }

    final class Coordinator: NSObject, DataScannerViewControllerDelegate {
        fileprivate weak var scanner: DataScannerViewController?
        private let onScan: (String) -> Void
        private var didScan = false

        init(onScan: @escaping (String) -> Void) {
            self.onScan = onScan
        }

        func startIfNeeded() {
            guard let scanner else { return }
            guard DataScannerViewController.isAvailable else { return }
            guard !scanner.isScanning else { return }

            do {
                try scanner.startScanning()
            } catch {
                print("Failed to start scanning:", error)
            }
        }

        func stopIfNeeded() {
            guard let scanner, scanner.isScanning else { return }
            scanner.stopScanning()
        }

        // Some barcodes show up as updates depending on tracking state.
        func dataScanner(_ dataScanner: DataScannerViewController,
                         didAdd addedItems: [RecognizedItem],
                         allItems: [RecognizedItem]) {
            handle(items: addedItems)
        }

        func dataScanner(_ dataScanner: DataScannerViewController,
                         didUpdate updatedItems: [RecognizedItem],
                         allItems: [RecognizedItem]) {
            handle(items: updatedItems)
        }

        private func handle(items: [RecognizedItem]) {
            guard !didScan else { return }

            for item in items {
                guard case let .barcode(barcode) = item else { continue }
                guard let payload = barcode.payloadStringValue, !payload.isEmpty else { continue }

                didScan = true
                onScan(payload)

                // Stop scanning after first scan to prevent repeats
                stopIfNeeded()
                break
            }
        }

        func makeFallbackController(message: String) -> UIViewController {
            let label = UILabel()
            label.text = message
            label.numberOfLines = 0
            label.textAlignment = .center

            let vc = UIViewController()
            vc.view.backgroundColor = .systemBackground
            label.translatesAutoresizingMaskIntoConstraints = false
            vc.view.addSubview(label)
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor, constant: 24),
                label.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor, constant: -24),
                label.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor)
            ])
            return vc
        }
    }
}
