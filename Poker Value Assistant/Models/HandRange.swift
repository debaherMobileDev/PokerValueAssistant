//
//  HandRange.swift
//  Poker Value Assistant
//
//  Created on 01/04/2026.
//

import Foundation

struct HandRange: Hashable {
    let name: String
    let hands: Set<String> // e.g., ["AA", "KK", "AKs", "AKo"]
    
    static let tight = HandRange(
        name: "Tight (Premium)",
        hands: Set([
            "AA", "KK", "QQ", "JJ", "TT",
            "AKs", "AKo", "AQs", "AJs", "KQs"
        ])
    )
    
    static let medium = HandRange(
        name: "Medium",
        hands: Set([
            "AA", "KK", "QQ", "JJ", "TT", "99", "88", "77",
            "AKs", "AKo", "AQs", "AQo", "AJs", "AJo", "ATs",
            "KQs", "KQo", "KJs", "KTs", "QJs", "QTs", "JTs"
        ])
    )
    
    static let loose = HandRange(
        name: "Loose (Wide)",
        hands: Set([
            "AA", "KK", "QQ", "JJ", "TT", "99", "88", "77", "66", "55", "44", "33", "22",
            "AKs", "AKo", "AQs", "AQo", "AJs", "AJo", "ATs", "ATo", "A9s", "A8s", "A7s", "A6s", "A5s", "A4s", "A3s", "A2s",
            "KQs", "KQo", "KJs", "KJo", "KTs", "KTo", "K9s", "K8s",
            "QJs", "QJo", "QTs", "QTo", "Q9s",
            "JTs", "JTo", "J9s", "T9s", "98s", "87s", "76s", "65s"
        ])
    )
    
    static let allRanges = [tight, medium, loose]
}

extension HandRange {
    static func notationForHoleCards(_ card1: Card, _ card2: Card) -> String {
        let higher = max(card1.rank, card2.rank)
        let lower = min(card1.rank, card2.rank)
        
        let suited = card1.suit == card2.suit
        let suffix = suited ? "s" : (higher == lower ? "" : "o")
        
        return "\(higher.symbol)\(lower.symbol)\(suffix)"
    }
}

