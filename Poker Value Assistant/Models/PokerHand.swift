//
//  PokerHand.swift
//  Poker Value Assistant
//
//  Created on 01/04/2026.
//

import Foundation

enum HandRanking: Int, Comparable, CaseIterable {
    case highCard = 0
    case onePair = 1
    case twoPair = 2
    case threeOfAKind = 3
    case straight = 4
    case flush = 5
    case fullHouse = 6
    case fourOfAKind = 7
    case straightFlush = 8
    case royalFlush = 9
    
    var displayName: String {
        switch self {
        case .highCard: return "High Card"
        case .onePair: return "Pair"
        case .twoPair: return "Two Pair"
        case .threeOfAKind: return "Three of a Kind"
        case .straight: return "Straight"
        case .flush: return "Flush"
        case .fullHouse: return "Full House"
        case .fourOfAKind: return "Four of a Kind"
        case .straightFlush: return "Straight Flush"
        case .royalFlush: return "Royal Flush"
        }
    }
    
    var description: String {
        switch self {
        case .highCard: return "No matching cards"
        case .onePair: return "Two cards of the same rank"
        case .twoPair: return "Two different pairs"
        case .threeOfAKind: return "Three cards of the same rank"
        case .straight: return "Five cards in sequence"
        case .flush: return "Five cards of the same suit"
        case .fullHouse: return "Three of a kind + pair"
        case .fourOfAKind: return "Four cards of the same rank"
        case .straightFlush: return "Straight with all same suit"
        case .royalFlush: return "A-K-Q-J-T of the same suit"
        }
    }
    
    static func < (lhs: HandRanking, rhs: HandRanking) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

struct PokerHand: Identifiable {
    let id = UUID()
    let cards: [Card]
    let ranking: HandRanking
    let value: [Int] // For tie-breaking
    
    var strengthLevel: HandStrength {
        switch ranking {
        case .royalFlush, .straightFlush, .fourOfAKind:
            return .strong
        case .fullHouse, .flush, .straight:
            return .medium
        case .threeOfAKind, .twoPair:
            return .medium
        case .onePair, .highCard:
            return .weak
        }
    }
}

enum HandStrength: String {
    case strong = "Strong"
    case medium = "Medium"
    case weak = "Weak"
    
    var color: String {
        switch self {
        case .strong: return "green"
        case .medium: return "orange"
        case .weak: return "red"
        }
    }
}

