//
//  CardView.swift
//  Poker Value Assistant
//
//  Created on 01/04/2026.
//

import SwiftUI

struct CardView: View {
    let card: Card
    let size: CardSize
    let isSelected: Bool
    
    init(card: Card, size: CardSize = .medium, isSelected: Bool = false) {
        self.card = card
        self.size = size
        self.isSelected = isSelected
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size.cornerRadius)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
            
            if isSelected {
                RoundedRectangle(cornerRadius: size.cornerRadius)
                    .stroke(Color.green, lineWidth: 2)
            }
            
            VStack(spacing: 2) {
                Text(card.rank.symbol)
                    .font(.system(size: size.fontSize, weight: .bold))
                    .foregroundColor(card.suit.color == "red" ? .red : .black)
                
                Text(card.suit.rawValue)
                    .font(.system(size: size.fontSize * 0.8))
            }
        }
        .frame(width: size.width, height: size.height)
    }
}

enum CardSize {
    case small
    case medium
    case large
    
    var width: CGFloat {
        switch self {
        case .small: return 40
        case .medium: return 50
        case .large: return 70
        }
    }
    
    var height: CGFloat {
        return width * 1.4
    }
    
    var fontSize: CGFloat {
        switch self {
        case .small: return 14
        case .medium: return 18
        case .large: return 24
        }
    }
    
    var cornerRadius: CGFloat {
        return 6
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            CardView(card: Card(rank: .ace, suit: .spades), size: .small)
            CardView(card: Card(rank: .king, suit: .hearts), size: .medium)
            CardView(card: Card(rank: .queen, suit: .diamonds), size: .large, isSelected: true)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

