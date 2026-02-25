//
//  FlowLayoutView.swift
//  EatNeat
//
//  Created by Oscar Horner on 24/02/2026.
//
// Supports a 'flow layout' which is an adaptive view that allows variable width elements (such as pills or capsules) to render in line, then overflow onto the next line neatly if there is not enough space.

import SwiftUI

struct FlowLayoutView: Layout {
    
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize,
                      subviews: Subviews,
                      cache: inout ()) -> CGSize {
        
        let maxWidth = proposal.width ?? .infinity
        
        var currentRowWidth: CGFloat = 0
        var currentRowHeight: CGFloat = 0
        var totalHeight: CGFloat = 0
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            
            if currentRowWidth + size.width > maxWidth {
                totalHeight += currentRowHeight + spacing
                currentRowWidth = size.width + spacing
                currentRowHeight = size.height
            } else {
                currentRowWidth += size.width + spacing
                currentRowHeight = max(currentRowHeight, size.height)
            }
        }
        
        totalHeight += currentRowHeight
        
        return CGSize(width: maxWidth, height: totalHeight)
    }
    
    func placeSubviews(in bounds: CGRect,
                       proposal: ProposedViewSize,
                       subviews: Subviews,
                       cache: inout ()) {
        
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            
            if x + size.width > bounds.maxX {
                x = bounds.minX
                y += rowHeight + spacing
                rowHeight = 0
            }
            
            subview.place(
                at: CGPoint(x: x, y: y),
                proposal: ProposedViewSize(size)
            )
            
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}
