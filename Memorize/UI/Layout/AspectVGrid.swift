//
//  AspectVGrid.swift
//  Memorize
//
//  Created by KC Thomas on 12/28/25.
//

import SwiftUI

struct AspectVGrid<Item: Identifiable, ItemView: View>: View {
    var items: [Item]
    var aspectRatio: CGFloat = 1.0
    let content: (Item) -> ItemView
    
    init(
        _ items: [Item],
        aspectRatio: CGFloat,
        @ViewBuilder content: @escaping (Item) -> ItemView
    ) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            let gridItemWidth = gridItemWidthThatFits(
                numItems: items.count,
                size: geometry.size,
                aspectRatio: aspectRatio
            )
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: gridItemWidth), spacing: 0)],
                spacing: 0
            ) {
                ForEach(items) { item in
                    content(item)
                        .aspectRatio(aspectRatio, contentMode: .fit)
                }
            }
        }
    }
    
    private func gridItemWidthThatFits(
        numItems: Int,
        size: CGSize,
        aspectRatio: CGFloat
    ) -> CGFloat {
        let numItems = CGFloat(numItems)
        var columnCount = 1.0
        repeat {
            let width = size.width / columnCount
            let height = width / aspectRatio
            let rowCount = (numItems / columnCount).rounded(.up)
            if rowCount * height < size.height {
                return (size.width / columnCount).rounded(.down)
            }
            columnCount += 1
        } while columnCount < numItems
        return min(size.width / numItems, size.height * aspectRatio).rounded(.down)
    }
}
