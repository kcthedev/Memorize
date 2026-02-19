import Testing
@testable import Memorize

struct MemorizeTests {
    private static let emojis = ["👻", "🎃", "🕷️", "😈", "💀", "❄️", "🧙‍♀️", "🙀", "👹", "😱", "☠️", "🍭"]

    private var game = MemorizeGame(numberOfPairs: 12) { index in
        emojis[index]
    }

    @Test mutating func testChooseCard() {
        game.choose(0)

        #expect(!game.shouldFlipBack)
        #expect(game.score == 0)
        
        #expect(game.cards[0].isFaceUp)
        #expect(!game.cards[0].isMatched)
    }

    @Test mutating func testChooseTwoMatchingCards() {
        game.choose(0)
        game.choose(1)

        #expect(!game.shouldFlipBack)
        #expect(game.score == 12)
        
        #expect(game.cards[0].isFaceUp)
        #expect(game.cards[1].isFaceUp)
        #expect(game.cards[0].isMatched)
        #expect(game.cards[1].isMatched)
    }

    @Test mutating func testChooseTwoUnmatchingUnseenCards() {
        game.choose(0)
        game.choose(2)

        // Flipping cards back handled by the ViewModel
        #expect(game.shouldFlipBack)
        game.turnUnmatchedCardsDown()
        
        #expect(game.score == 0)

        #expect(!game.cards[0].isMatched)
        #expect(!game.cards[2].isMatched)
    }

    @Test mutating func testChooseTwoUnmatchingSeenCards() {
        game.choose(0)
        game.choose(2)

        // Flipping cards back handled by the ViewModel
        #expect(game.shouldFlipBack)
        game.turnUnmatchedCardsDown()
        
        #expect(game.score == 0)
        
        game.choose(0)
        game.choose(2)
        
        #expect(game.shouldFlipBack)
        #expect(game.score == -2)

        #expect(!game.cards[0].isMatched)
        #expect(!game.cards[2].isMatched)
        
        #expect(game.cards[0].hasBeenSeen)
        #expect(game.cards[2].hasBeenSeen)
    }
}
