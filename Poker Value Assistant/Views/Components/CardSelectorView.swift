//
//  CardSelectorView.swift
//  Poker Value Assistant
//
//  Created on 01/04/2026.
//

import SwiftUI

struct CardSelectorView: View {
    let availableCards: [Card]
    let onCardSelected: (Card) -> Void
    
    @State private var selectedSuit: Suit = .spades
    
    var body: some View {
        VStack(spacing: 16) {
            // Suit selector
            HStack(spacing: 12) {
                ForEach(Suit.allCases, id: \.self) { suit in
                    Button(action: {
                        selectedSuit = suit
                    }) {
                        Text(suit.rawValue)
                            .font(.title2)
                            .frame(width: 50, height: 50)
                            .background(selectedSuit == suit ? Color.green : Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
            }
            
            // Rank selector
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 8) {
                ForEach(Rank.allCases.reversed(), id: \.self) { rank in
                    let card = Card(rank: rank, suit: selectedSuit)
                    let isAvailable = availableCards.contains(card)
                    
                    Button(action: {
                        if isAvailable {
                            onCardSelected(card)
                        }
                    }) {
                        CardView(card: card, size: .medium)
                            .opacity(isAvailable ? 1.0 : 0.3)
                    }
                    .disabled(!isAvailable)
                }
            }
        }
        .padding()
    }
}

