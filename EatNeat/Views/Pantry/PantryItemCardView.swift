//
//  PantryItemCardView.swift
//  EatNeat
//
//  Created by Oscar Horner on 18/10/2025.
//

import SwiftUI
import Kingfisher

struct PantryItemCardView: View {
    let item: PantryItem
    let onTap: () -> Void
    
    let material = AnyShapeStyle(.ultraThinMaterial.opacity(0.74))

    private var weightText: String? {
        guard let qty = item.weightQuantity,
              let unit = item.weightUnit else { return nil }

        let valueString: String
        if qty == floor(qty) {
            valueString = String(format: "%.0f", qty)
        } else {
            valueString = String(format: "%.2f", qty)
        }

        return "\(valueString) \(unit.rawValue)"
    }

    private var subtitleText: String {
        if let weightText = weightText {
            return "\(item.quantity)x • \(weightText)"
        }
        return "\(item.quantity)x"
    }

    var body: some View {
        let cardWidth  = min(UIScreen.main.bounds.width * 0.35, 140)
        let cardHeight = min(UIScreen.main.bounds.width * 0.32, 132)

        ZStack {

            // MARK: Background Image
            Group {
                if let url = item.imageURL {
                    KFImage(url)
                        .downsampling(size: CGSize(width: cardWidth * 2,
                                                   height: cardHeight * 2))
                        .cancelOnDisappear(true)
                        .resizable()
                        .scaledToFill()
                        .scaleEffect(0.75)
                } else {
                    fallbackBackground
                }
            }
            .frame(width: cardWidth, height: cardHeight)
            .clipped()

            // MARK: Top Banner
            VStack {
                topBanner
                Spacer()
                bottomBanner
            }
        }
        .frame(width: cardWidth, height: cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppStyle.containerGray, lineWidth: 2)
        )
        .shadow(color: Color.black.opacity(0.06),
                radius: 3, x: 0, y: 1)
        .contentShape(RoundedRectangle(cornerRadius: 16))
        .onTapGesture {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            onTap()
        }
    }

    // MARK: Top Banner (Qty / Weight)

    private var topBanner: some View {
        HStack {
            Text(subtitleText)
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(1)
                .foregroundColor(.primary)

            Spacer()
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .frame(maxWidth: .infinity)
        .background(material)
    }

    // MARK: Bottom Banner (Product Name)

    private var bottomBanner: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {

                Rectangle()
                    .fill(material)

                FadingText(
                    text: item.name,
                    containerWidth: geo.size.width - 20, // account for padding
                    font: .subheadline.weight(.semibold)
                )
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
            }
        }
        .frame(height: 36)
    }

    // MARK: Fallback Background

    private var fallbackBackground: some View {
        ZStack {
            Color(.secondarySystemBackground)
            Image(systemName: "shippingbox")
                .font(.system(size: 26, weight: .semibold))
                .foregroundColor(.secondary)
        }
    }
}

private struct FadingText: View {
    let text: String
    let containerWidth: CGFloat
    let font: Font

    var body: some View {
        Text(text)
            .font(font)
            .foregroundColor(.primary)
            .fixedSize(horizontal: true, vertical: false)
            .frame(width: containerWidth, alignment: .leading)
            .clipped()
            .mask(
                LinearGradient(
                    stops: [
                        .init(color: .black, location: 0),
                        .init(color: .black, location: 0.8),
                        .init(color: .clear, location: 1)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
    }
}
