import Foundation

struct MemorizeGame<CardContent: Equatable> {
    private(set) var cards: [Card<CardContent>] = []
    private(set) var score = 0
    var shouldFlipBack = false
    
    init(
        numberOfPairs: Int,
        contentBuilder: (Int) -> CardContent
    ) {
        for pairIndex in 0 ..< max(2, numberOfPairs) {
            let content = contentBuilder(pairIndex)
            cards.append(
                Card(id: 2*pairIndex, content: content)
            )
            cards.append(
                Card(id: 2*pairIndex + 1, content: content)
            )
        }
    }

    mutating func shuffle() {
        cards.shuffle()
    }

    mutating func choose(_ card: Card<CardContent>) {
        if let index = indexOf(card) {
            choose(index)
        }
    }
    
    mutating func choose(_ index: Int) {
        cards[index].isFaceUp = true
        if (getFaceUpCards().count > 1) {
            evaluateGameState()
        }
    }
    
    private mutating func evaluateGameState() {
        let faceUpCards = getFaceUpCards()
        let card0 = faceUpCards[0], card1 = faceUpCards[1]
        if (card0.content == card1.content) {
            cards[indexOf(card0)!].isMatched = true
            cards[indexOf(card1)!].isMatched = true
            score += 2 + card0.bonus + card1.bonus
        } else {
            if card0.hasBeenSeen { score -= 1 }
            if card1.hasBeenSeen { score -= 1 }
            shouldFlipBack = true
        }
    }

    private func indexOf(_ cardToBeMatched: Card<CardContent>) -> Int? {
        for index in cards.indices {
            if (cards[index].id == cardToBeMatched.id) {
                return index
            }
        }
        return nil
    }

    private func getFaceUpCards() -> [Card<CardContent>] {
        cards.filter { $0.isFaceUp && !$0.isMatched }
    }

    mutating func turnUnmatchedCardsDown() {
        for index in cards.indices {
            if (!cards[index].isMatched) {
                cards[index].isFaceUp = false
            }
        }
        shouldFlipBack = false
    }
}
