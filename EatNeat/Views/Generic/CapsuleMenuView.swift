//
//  CapsuleMenuView.swift
//  EatNeat
//
//  Created by Oscar Horner on 15/02/2026.
//
// A CapsuleView but with a clickable menu used for things such as filters.

import SwiftUI

struct CapsuleMenu<Option: Hashable>: View {

    let title: String
    private let selection: Binding<Option>? // selection is ONLY required if customLabel is not supplied because customLabel means the parent view doesn't care about the last selected value as it is rendering those values as some collection elsewhere
    let options: [Option]
    let display: (Option) -> String
    let onConfirm: ((Option) -> Void)?
    let color: Color
    private let customLabel: AnyView?

    // MARK: - Stateful Initialiser (requires selection)

    init(
        title: String,
        selection: Binding<Option>,
        options: [Option],
        display: @escaping (Option) -> String,
        onConfirm: ((Option) -> Void)? = nil,
        color: Color? = nil
    ) {
        self.title = title
        self.selection = selection
        self.options = options
        self.display = display
        self.onConfirm = onConfirm
        self.color = color ?? AppStyle.primary
        self.customLabel = nil
    }

    // MARK: - Action-Only Initialiser (no selection required)

    init<Label: View>(
        title: String,
        options: [Option],
        display: @escaping (Option) -> String,
        onConfirm: ((Option) -> Void)? = nil,
        color: Color? = nil,
        @ViewBuilder label: () -> Label
    ) {
        self.title = title
        self.selection = nil                     // no binding stored
        self.options = options
        self.display = display
        self.onConfirm = onConfirm
        self.color = color ?? AppStyle.primary
        self.customLabel = AnyView(label())
    }

    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button {
                    selection?.wrappedValue = option   // only update if binding exists
                    onConfirm?(option)
                } label: {
                    Text(display(option))
                }
            }
        } label: {
            if let customLabel {
                customLabel
            } else if let selection {
                CapsuleView(
                    content: .text(display(selection.wrappedValue)),
                    color: color,
                    heavy: false,
                    action: {}
                )
            } else {
                CapsuleView(
                    content: .text(title),
                    color: color,
                    heavy: false,
                    action: {}
                )
            }
        }
        .menuStyle(.button)
        .buttonStyle(.plain)
        .accessibilityLabel(Text(title))
    }
}
