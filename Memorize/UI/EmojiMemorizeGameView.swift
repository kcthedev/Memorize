import SwiftUI

struct EmojiMemorizeGameView: View {
    @ObservedObject var viewModel: MemorizeEmojiViewModel
    
    private let aspectRatio: CGFloat = 2/3
    
    var body: some View {
        VStack {
            cards
                .foregroundColor(AppTheme.primaryColor)
            HStack {
                score
                Spacer()
                deck
                Spacer()
                shuffle
            }
        }
        .padding()
    }
    
    private var score: some View {
        Text("Score: \(viewModel.score)")
            .animation(nil)
    }
    
    private var shuffle: some View {
        Button("Shuffle") {
            withAnimation {
                viewModel.shuffle()
            }
        }
    }
    
    private var cards: some View {
        AspectVGrid(viewModel.cards,aspectRatio: aspectRatio) { card in
            if isDealt(card) {
                CardView(card)
                    .matchedGeometryEffect(
                        id: card.id,
                        in: dealingNamespace
                    )
                    .padding(4)
                    .overlay(FlyingNumber(number: scoreChange(causedBy: card)))
                    .zIndex(scoreChange(causedBy: card) != 0 ? 100 : 0)
                    .onTapGesture {
                        choose(card)
                    }
                    .transition(
                        .asymmetric(
                            insertion: .identity,
                            removal: .identity
                        )
                    )
            }
        }
    }
    
    @State private var dealtCards = Set<EmojiCard.ID>()
    
    private func isDealt(_ card: EmojiCard) -> Bool {
        dealtCards.contains(card.id)
    }
    
    private var undealtCards: [EmojiCard] {
        viewModel.cards.filter { card in
            !isDealt(card)
        }
    }
    
    @Namespace private var dealingNamespace
    
    @ViewBuilder
    private var deck: some View {
        // Necessary for UI Tests
        if !undealtCards.isEmpty {
            ZStack {
                ForEach(undealtCards) { card in
                    CardView(card)
                        .matchedGeometryEffect(
                            id: card.id,
                            in: dealingNamespace
                        )
                        .transition(
                            .asymmetric(
                                insertion: .identity,
                                removal: .identity
                            )
                        )
                }
            }
            .frame(
                width: Constants.deckWidth,
                height: Constants.deckWidth / aspectRatio
            )
            .onTapGesture {
                deal()
            }
            .foregroundColor(AppTheme.primaryColor)
            .accessibilityElement(children: .combine)
            .accessibilityIdentifier("deck")
        }
    }
    
    private func deal() {
        var delay: TimeInterval = 0
        for card in viewModel.cards {
            withAnimation(Constants.dealAnimation.delay(delay)) {
                _ = dealtCards.insert(card.id)
            }
            delay += Constants.dealDuration
        }
    }
    
    private func choose(_ card: EmojiCard) {
        withAnimation {
            let scoreBeforeChoosing = viewModel.score
            viewModel.choose(card)
            let scoreChange = viewModel.score - scoreBeforeChoosing
            lastScoreChange = (scoreChange, causedByCardId: card.id)
        }
    }
    
    @State private var lastScoreChange = (0, causedByCardId: -1)
    
    private func scoreChange(causedBy card: EmojiCard) -> Int {
        let (amount, id) = lastScoreChange
        return card.id == id ? amount : 0
    }
    
    private struct Constants {
        static let deckWidth: CGFloat = 50
        static let dealAnimation: Animation = .easeOut(duration: 0.5)
        static let dealDuration: TimeInterval = 0.1
    }
}

#Preview {
    EmojiMemorizeGameView(viewModel: MemorizeEmojiViewModel())
}
