//
//  BeforeScanView.swift
//  EatNeat
//
//  Created by Oscar Horner on 07/02/2026.
//
// Represents the landing/guidance page before opening each scanner. Togglable by the user, it adds another click so to make things more friendly we allow them to check 'Don't show this again' and save that preference.

import SwiftUI

struct ScannerLandingView: View {
    let sheetTitle: String
    let sheetDescription: String
    let sheetIcon: String
    let instructions: [String]

    let launchScanner: () -> Void
    let dismiss: () -> Void
    let isProcessing: Bool
    @State private var showHelp = false

    @AppStorage("pref.scanning.skipLanding") private var skipLanding = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {

                    // MARK: Scanner button
                    Button {
                        guard !isProcessing else { return }
                        launchScanner()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(.thinMaterial)

                            VStack(spacing: 12) {
                                Image(systemName: sheetIcon)
                                    .font(.system(size: 72, weight: .semibold))
                                    .foregroundStyle(isProcessing ? .secondary : .primary)
                                    .symbolEffect(
                                        .pulse,
                                        options: isProcessing ? .repeating : .default,
                                        value: isProcessing
                                    )

                                Text(isProcessing ? "Processing…" : "Tap to scan")
                                    .font(.headline)
                                    .foregroundStyle(isProcessing ? .secondary : .primary)
                            }
                            .padding(.vertical, 26)
                        }
                        .frame(maxWidth: 360)
                    }
                    .buttonStyle(.plain)
                    .disabled(isProcessing)
                    .opacity(isProcessing ? 0.85 : 1.0)

                    // MARK: Description
                    Text(sheetDescription)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    // MARK: Instructions container
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(instructions, id: \.self) { text in
                            bullet(text)
                        }
                    }
                    .padding()
                    .frame(maxWidth: 520, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(.thinMaterial)
                    )
                    .padding(.horizontal)

                    // MARK: Skip next time - need to improve this logic before I re-add it
                    // skipNextTime

                    if isProcessing {
                        ProgressView("Processing…")
                            .padding(.top, 6)
                    }

                    Spacer(minLength: 24)
                }
                .padding(.top, 16)
                .padding(.horizontal, 16)
            }
            .navigationTitle(sheetTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showHelp = true
                    } label: {
                        Image(systemName: "questionmark.circle")
                    }
                }
            }
            .sheet(isPresented: $showHelp) {
                HelpView(
                    title: sheetTitle,
                    message: sheetDescription,
                    faqs: [
                        (
                            question: "Skip next time?",
                            answer: "Enable this to open the scanner immediately next time."
                        )
                    ]
                )
            }
        }
    }

    // MARK: Skip next time row 
    var skipNextTime: some View {
        Button {
            skipLanding.toggle()
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        } label: {
            HStack(spacing: 10) {
                Image(systemName: skipLanding ? "checkmark.square.fill" : "square")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(skipLanding ? .blue : .secondary)

                Text("Don't show this again.")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)

                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .frame(maxWidth: 520)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color(.secondarySystemBackground))
            )
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
        .padding(.top, 4)
    }

    // MARK: Bullet helper
    private func bullet(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Text("•")
                .font(.body.weight(.semibold))
                .padding(.top, 1)
            Text(text)
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }
}
