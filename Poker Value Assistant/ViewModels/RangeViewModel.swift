//
//  RangeViewModel.swift
//  Poker Value Assistant
//
//  Created on 01/04/2026.
//

import Foundation
import SwiftUI

class RangeViewModel: ObservableObject {
    @Published var selectedHoleCards: [Card] = []
    @Published var selectedRange: HandRange = .medium
    @Published var highlightMode: RangeHighlightMode = .stronger
    
    var holeCardsNotation: String {
        guard selectedHoleCards.count == 2 else { return "—" }
        return HandRange.notationForHoleCards(selectedHoleCards[0], selectedHoleCards[1])
    }
    
    var isInSelectedRange: Bool {
        guard selectedHoleCards.count == 2 else { return false }
        return selectedRange.hands.contains(holeCardsNotation)
    }
    
    func selectCard(_ card: Card) {
        if selectedHoleCards.count < 2 {
            selectedHoleCards.append(card)
        }
    }
    
    func removeCard(_ card: Card) {
        selectedHoleCards.removeAll { $0 == card }
    }
    
    func clearSelection() {
        selectedHoleCards.removeAll()
    }
    
    func shouldHighlight(_ handNotation: String) -> Bool {
        guard selectedHoleCards.count == 2 else { return false }
        
        let currentNotation = holeCardsNotation
        guard let currentIndex = getRangeStrength(currentNotation) else { return false }
        guard let checkIndex = getRangeStrength(handNotation) else { return false }
        
        switch highlightMode {
        case .stronger:
            return checkIndex > currentIndex
        case .weaker:
            return checkIndex < currentIndex
        case .all:
            return true
        }
    }
    
    private func getRangeStrength(_ notation: String) -> Int? {
        if HandRange.tight.hands.contains(notation) { return 3 }
        if HandRange.medium.hands.contains(notation) { return 2 }
        if HandRange.loose.hands.contains(notation) { return 1 }
        return 0
    }
}

enum RangeHighlightMode: String, CaseIterable {
    case stronger = "Stronger"
    case weaker = "Weaker"
    case all = "All in Range"
}

