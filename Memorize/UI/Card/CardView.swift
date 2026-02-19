//
//  CardView.swift
//  Memorize
//
//  Created by KC Thomas on 12/28/25.
//

import SwiftUI

struct CardView: View {
    let card: EmojiCard
    
    init(_ card: EmojiCard) {
        self.card = card
    }
    
    var body: some View {
        TimelineView(.animation) { _ in
            if card.isFaceUp || !card.isMatched {
                Pie(endAngle: .degrees(360 * card.bonusPercentRemaining))
                    .opacity(Constants.Pie.timerOpacity)
                    .overlay(cardContents.padding(Constants.Pie.inset))
                    .padding(Constants.inset)
                    .cardify(isFaceUp: card.isFaceUp)
                    .transition(.scale)
            } else {
                Color.clear
            }
        }
    }
    
    var cardContents: some View {
        Text(card.content)
            .font(.system(size: Constants.FontSize.larget))
            .minimumScaleFactor(Constants.FontSize.scaleFactor)
            .multilineTextAlignment(.center)
            .aspectRatio(1, contentMode: .fit)
            .rotationEffect(.degrees(card.isMatched ? 360 : 0))
            .animation(.spin(duration: 1), value: card.isMatched)
    }
    
    private struct Constants {
        static let inset: CGFloat = 8
        struct FontSize {
            static let larget: CGFloat = 200
            static let smallest: CGFloat = 10
            static let scaleFactor: CGFloat = smallest / larget
        }
        struct Pie {
            static let timerOpacity: CGFloat = 0.4
            static let inset: CGFloat = 8
        }
    }
}

extension Animation {
    static func spin(duration: TimeInterval) -> Animation {
        linear(duration: 0.6).repeatForever(autoreverses: false)
    }
}

#Preview {
    VStack {
        HStack {
            CardView(
                Card(
                    id: 1,
                    content: "🎃",
                    isFaceUp: true
                )
            )
            .aspectRatio(2/3, contentMode: .fit)
            CardView(
                Card(
                    id: 1,
                    content: "🎃",
                    isFaceUp: false
                )
            )
        }
        HStack {
            CardView(
                Card(
                    id: 1,
                    content: "This is some really long text and I hope it fits",
                    isFaceUp: true,
                    isMatched: true
                )
            )
            CardView(
                Card(
                    id: 1,
                    content: "🎃",
                    isFaceUp: false,
                    isMatched: true
                )
            )
        }
    }
    .padding(12)
}
