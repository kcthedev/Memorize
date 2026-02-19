import SwiftUI

@MainActor
class MemorizeEmojiViewModel: ObservableObject {
    private static let emojis = ["👻", "🎃", "🕷️", "😈", "💀", "❄️", "🧙‍♀️", "🙀", "👹", "😱", "☠️", "🍭"]
    
    static func createMemorizeGame() -> MemorizeGame<String> {
        MemorizeGame<String>(numberOfPairs: 12) { index in
            if emojis.indices.contains(index) {
                emojis[index]
            } else {
                "‼️"
            }
        }
    }

    @Published private var memorizeGame = createMemorizeGame()
    
    var cards: Array<EmojiCard> {
        memorizeGame.cards
    }
    
    var score: Int {
        memorizeGame.score
    }
    
    // MARK: Intent
    func shuffle() {
        memorizeGame.shuffle()
    }
    
    func choose(_ card: EmojiCard) {
        memorizeGame.choose(card)
        
        if memorizeGame.shouldFlipBack {
            Task {
                try? await Task.sleep(for: .seconds(1))
                withAnimation {
                    memorizeGame.turnUnmatchedCardsDown()
                }
            }
        }
    }
}
