//
//  Card.swift
//  Memorize
//
//  Created by KC Thomas on 2/8/26.
//

import Foundation

typealias EmojiCard = Card<String>

struct Card<CardContent: Equatable>: Identifiable, CustomDebugStringConvertible {
    let id: Int
    let content: CardContent
    
    var isFaceUp = false {
        didSet {
            if isFaceUp {
                startUsingBonusTime()
            } else {
                stopUsingBonusTime()
            }
            
            // WAS face up but is now face down
            if oldValue && !isFaceUp {
                hasBeenSeen = true
            }
        }
    }
    
    var hasBeenSeen = false
    
    var isMatched = false {
        didSet {
            if isMatched {
                stopUsingBonusTime()
            }
        }
    }
    
    var debugDescription: String {
        "id: \(id), content: \(content)"
    }
    
    // MARK: - Bonus Time
    
    // call this when the card transitions to face up state
    private mutating func startUsingBonusTime() {
        if isFaceUp && !isMatched && bonusPercentRemaining > 0, lastFaceUpDate == nil {
            lastFaceUpDate = Date()
        }
    }
    
    // call this when the card goes back face down or gets matched
    private mutating func stopUsingBonusTime() {
        pastFaceUpTime = faceUpTime
        lastFaceUpDate = nil
    }
    
    // the bonus earned so far (one point for every second of the bonusTimeLimit that was not used)
    // this gets smaller and smaller the longer the card remains face up without being matched
    var bonus: Int {
        Int(bonusTimeLimit * bonusPercentRemaining)
    }
    
    // percentage of the bonus time remaining
    var bonusPercentRemaining: Double {
        bonusTimeLimit > 0 ? max(0, bonusTimeLimit - faceUpTime)/bonusTimeLimit : 0
    }
    
    // how long this card has ever been face up and unmatched during its lifetime
    // basically, pastFaceUpTime + time since lastFaceUpDate
    var faceUpTime: TimeInterval {
        if let lastFaceUpDate {
            return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
        } else {
            return pastFaceUpTime
        }
    }
    
    // can be zero which would mean "no bonus available" for matching this card quickly
    var bonusTimeLimit: TimeInterval = 6
    
    // the last time this card was turned face up
    var lastFaceUpDate: Date?
    
    // the accumulated time this card was face up in the past
    // (i.e. not including the current time it's been face up if it is currently so)
    var pastFaceUpTime: TimeInterval = 0
}
