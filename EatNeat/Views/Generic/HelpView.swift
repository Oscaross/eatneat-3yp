//
//  HelpView.swift
//  EatNeat
//
//  Created by Oscar Horner on 09/11/2025.
//

import SwiftUI

struct HelpView: View {
    var title: String
    var message: String
    var faqs: [(question: String, answer: String)] = []

    @Environment(\.dismiss) private var dismiss
    @State private var expandedIndices: Set<Int> = []

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(message)
                        .font(.body)
                        .foregroundColor(.secondary)

                    if !faqs.isEmpty {
                        Divider()
                        Text("FAQs")
                            .font(.headline)
                            .padding(.bottom, 4)

                        ForEach(faqs.indices, id: \.self) { i in
                            FAQRow(
                                question: faqs[i].question,
                                answer: faqs[i].answer,
                                isExpanded: expandedIndices.contains(i)
                            )
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    if expandedIndices.contains(i) {
                                        expandedIndices.remove(i)
                                    } else {
                                        expandedIndices.insert(i)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}

private struct FAQRow: View {
    var question: String
    var answer: String
    var isExpanded: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(question)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "chevron.right")
                    .rotationEffect(.degrees(isExpanded ? 90 : 0))
                    .foregroundColor(.secondary)
                    .font(.system(size: 12, weight: .semibold))
            }
            .contentShape(Rectangle()) // Full-row tap target

            if isExpanded {
                Text(answer)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .transition(
                        .opacity
                        .combined(with: .scale(scale: 0.98))
                    )
                    .animation(.easeInOut(duration: 0.25), value: isExpanded)
            }

            Divider()
        }
        .padding(.vertical, 4)
    }
}
