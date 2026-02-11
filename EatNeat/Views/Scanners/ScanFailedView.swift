//
//  ScanFailedView.swift
//  EatNeat
//
//  Created by Oscar Horner on 07/02/2026.
//
// Generic error screen for a failed scanning flow

import SwiftUI

struct ScanFailedView: View {

    // MARK: - Model
    let error: ScannerError

    // MARK: - Config
    let title: String
    let onDismiss: () -> Void
    let onTryAgain: (() -> Void)?

    init(
        title: String = "Scan Failed",
        error: ScannerError,
        onTryAgain: @escaping () -> Void,
        onDismiss: @escaping () -> Void
    ) {
        self.title = title
        self.error = error
        self.onTryAgain = onTryAgain
        self.onDismiss = onDismiss
    }
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {

                // MARK: Top Hero (compact)
                VStack(spacing: 10) {
                    Image(systemName: "xmark.octagon.fill")
                        .font(.system(size: 44, weight: .semibold))
                        .foregroundStyle(.red)

                    Text(title)
                        .font(.headline)

                    Text(error.getDescription())
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(20)
                .frame(maxWidth: 520)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(.thinMaterial)
                )
                .padding(.horizontal)

                // MARK: Suggestions (middle)
                VStack(alignment: .leading, spacing: 12) {
                    Text("Things to check")
                        .font(.subheadline.weight(.semibold))

                    if error.getSolutions().isEmpty {
                        Text("We aren't quite sure what went wrong here. Contact the developer directly to make a bug report and help identify the cause of this issue so it can be fixed in the future.")
                            .font(.body)
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(error.getSolutions(), id: \.self) { text in
                            bullet(text)
                        }
                    }
                }
                .padding(20)
                .frame(maxWidth: 520, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(.thinMaterial)
                )
                .padding(.horizontal)

                Spacer()

                // MARK: Bottom Action (anchored)
                if let onTryAgain = onTryAgain {
                    Button {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        onTryAgain()
                    } label: {
                        Text("Try Again")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(Color(.secondarySystemBackground))
                            )
                    }
                    .buttonStyle(.plain)
                    .frame(maxWidth: 520)
                    .padding(.horizontal)
                    .padding(.bottom, 12)
                }
            }
            .padding(.top, 16)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }


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
