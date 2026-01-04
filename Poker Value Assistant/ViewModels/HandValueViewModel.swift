//
//  HandValueViewModel.swift
//  Poker Value Assistant
//
//  Created on 01/04/2026.
//

import Foundation
import SwiftUI

class HandValueViewModel: ObservableObject {
    @Published var selectedHoleCards: [Card] = []
    @Published var selectedCommunityCards: [Card] = []
    @Published var currentHand: PokerHand?
    @Published var equity: Double = 0.0
    @Published var isCalculatingEquity: Bool = false
    @Published var selectedRange: HandRange = .medium
    
    private let calculator = PokerCalculatorService.shared
    
    var availableCards: [Card] {
        let used = Set(selectedHoleCards + selectedCommunityCards)
        return Card.deck().filter { !used.contains($0) }
    }
    
    var canAddHoleCard: Bool {
        return selectedHoleCards.count < 2
    }
    
    var canAddCommunityCard: Bool {
        return selectedCommunityCards.count < 5
    }
    
    func selectCard(_ card: Card, for cardType: CardSelectionType) {
        switch cardType {
        case .hole:
            if selectedHoleCards.count < 2 {
                selectedHoleCards.append(card)
                updateHand()
            }
        case .community:
            if selectedCommunityCards.count < 5 {
                selectedCommunityCards.append(card)
                updateHand()
            }
        }
    }
    
    func removeCard(_ card: Card, from cardType: CardSelectionType) {
        switch cardType {
        case .hole:
            selectedHoleCards.removeAll { $0 == card }
        case .community:
            selectedCommunityCards.removeAll { $0 == card }
        }
        updateHand()
    }
    
    func clearAllCards() {
        selectedHoleCards.removeAll()
        selectedCommunityCards.removeAll()
        currentHand = nil
        equity = 0.0
    }
    
    func clearCommunityCards() {
        selectedCommunityCards.removeAll()
        updateHand()
    }
    
    private func updateHand() {
        if selectedHoleCards.count == 2 {
            currentHand = calculator.evaluateHand(holeCards: selectedHoleCards, communityCards: selectedCommunityCards)
        } else {
            currentHand = nil
        }
    }
    
    func calculateEquity() {
        guard selectedHoleCards.count == 2 else { return }
        
        isCalculatingEquity = true
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            let calculatedEquity = self.calculator.calculateEquity(
                holeCards: self.selectedHoleCards,
                communityCards: self.selectedCommunityCards,
                against: self.selectedRange,
                iterations: 1000
            )
            
            DispatchQueue.main.async {
                self.equity = calculatedEquity
                self.isCalculatingEquity = false
            }
        }
    }
}

enum CardSelectionType {
    case hole
    case community
}

