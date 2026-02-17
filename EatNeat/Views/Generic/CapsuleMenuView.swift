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
    @Binding var selection: Option
    let options: [Option]
    let display: (Option) -> String
    let onConfirm: ((Option) -> Void)?
    let color: Color
    private let customLabel: AnyView?

    // MARK: - Default Capsule Initialiser

    init(
        title: String,
        selection: Binding<Option>,
        options: [Option],
        display: @escaping (Option) -> String,
        onConfirm: ((Option) -> Void)? = nil,
        color: Color? = nil
    ) {
        self.title = title
        self._selection = selection
        self.options = options
        self.display = display
        self.onConfirm = onConfirm
        self.color = color ?? AppStyle.primary
        self.customLabel = nil
    }

    // MARK: - Custom Label Initialiser

    init<Label: View>(
        title: String,
        selection: Binding<Option>,
        options: [Option],
        display: @escaping (Option) -> String,
        onConfirm: ((Option) -> Void)? = nil,
        color: Color? = nil,
        @ViewBuilder label: () -> Label
    ) {
        self.title = title
        self._selection = selection
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
                    selection = option
                    onConfirm?(option)
                } label: {
                    Text(display(option))
                }
            }
        } label: {
            if let customLabel {
                customLabel
            } else {
                CapsuleView(
                    content: .text(display(selection)),
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
