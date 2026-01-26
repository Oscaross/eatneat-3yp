//
//  ReceiptScannerView.swift
//  EatNeat
//
//  Created by Oscar Horner on 17/12/2025.
//

import SwiftUI
import VisionKit
import Vision
import CoreGraphics

struct ReceiptScannerView: UIViewControllerRepresentable {
    
    var onLinesExtracted: ([OCRLine]) -> Void // callback takes our list of OCRLines and returns void
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let vc = VNDocumentCameraViewController()
        vc.delegate = context.coordinator
        return vc
    }
    
    func updateUIViewController(
        _ uiViewController: VNDocumentCameraViewController,
        context: Context
    ) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onLinesExtracted: onLinesExtracted)
    }
    
    final class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        
        private let onLinesExtracted: ([OCRLine]) -> Void
        
        init(onLinesExtracted: @escaping ([OCRLine]) -> Void) {
            self.onLinesExtracted = onLinesExtracted
        }
        
        func documentCameraViewController(
            _ controller: VNDocumentCameraViewController,
            didFinishWith scan: VNDocumentCameraScan
        ) {
            controller.dismiss(animated: true)
            
            var allLines: [OCRLine] = []
            let group = DispatchGroup()
            
            for pageIndex in 0..<scan.pageCount {
                let image = scan.imageOfPage(at: pageIndex)
                group.enter()
                
                recognizeText(in: image) { lines in
                    allLines.append(contentsOf: lines)
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                self.onLinesExtracted(allLines)
            }
        }
        
        func documentCameraViewControllerDidCancel(
            _ controller: VNDocumentCameraViewController
        ) {
            controller.dismiss(animated: true)
        }
        
        func documentCameraViewController(
            _ controller: VNDocumentCameraViewController,
            didFailWithError error: Error
        ) {
            controller.dismiss(animated: true)
            print("Scanner error:", error)
        }
        
        // MARK: - OCR
        
        private func recognizeText(
            in image: UIImage,
            completion: @escaping ([OCRLine]) -> Void
        ) {
            guard let cgImage = image.cgImage else {
                completion([])
                return
            }
            
            let request = VNRecognizeTextRequest { request, _ in
                guard let observations =
                        request.results as? [VNRecognizedTextObservation]
                else {
                    completion([])
                    return
                }
                
                let lines: [OCRLine] = observations.compactMap { obs in
                    guard let candidate = obs.topCandidates(1).first else {
                        return nil
                    }
                    
                    print(candidate.string)
                    
                    return OCRLine(
                        text: candidate.string,
                        boundingBox: obs.boundingBox,
                        confidence: candidate.confidence
                    )
                }
                
                completion(lines)
            }
            
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true
            request.recognitionLanguages = ["en_GB"]
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            
            DispatchQueue.global(qos: .userInitiated).async {
                try? handler.perform([request])
            }
        }
    }
}
