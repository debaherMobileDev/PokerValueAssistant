//
//  QuickReferenceView.swift
//  Poker Value Assistant
//
//  Created on 01/04/2026.
//

import SwiftUI

struct QuickReferenceView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        VStack(spacing: 0) {
            Picker("Reference Type", selection: $selectedTab) {
                Text("Hand Rankings").tag(0)
                Text("Poker Terms").tag(1)
                Text("Strategy Tips").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            TabView(selection: $selectedTab) {
                HandRankingsView()
                    .tag(0)
                
                PokerTermsView()
                    .tag(1)
                
                StrategyTipsView()
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .navigationTitle("Quick Reference")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(UIColor.systemGroupedBackground))
    }
}

struct HandRankingsView: View {
    let rankings = HandRanking.allCases.reversed()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(rankings, id: \.self) { ranking in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("#\(10 - ranking.rawValue)")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 32, height: 32)
                                .background(Color(hex: "2DCC72"))
                                .cornerRadius(16)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(ranking.displayName)
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.black)
                                
                                Text(ranking.description)
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(.black.opacity(0.6))
                            }
                            
                            Spacer()
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                }
            }
            .padding()
        }
    }
}

struct PokerTermsView: View {
    let terms = [
        PokerTerm(term: "Equity", definition: "Your percentage chance of winning the hand based on current cards and potential outcomes."),
        PokerTerm(term: "Range", definition: "The spectrum of hands a player could have in a given situation."),
        PokerTerm(term: "Outs", definition: "Cards remaining in the deck that can improve your hand."),
        PokerTerm(term: "Pot Odds", definition: "The ratio of the current pot size to the cost of a contemplated call."),
        PokerTerm(term: "Position", definition: "Your seat at the table relative to the dealer button. Later position is advantageous."),
        PokerTerm(term: "Pocket Pair", definition: "Two cards of the same rank as your hole cards (e.g., 9♠9♥)."),
        PokerTerm(term: "Suited", definition: "Cards of the same suit, denoted with 's' (e.g., AKs = Ace-King suited)."),
        PokerTerm(term: "Offsuit", definition: "Cards of different suits, denoted with 'o' (e.g., AKo = Ace-King offsuit)."),
        PokerTerm(term: "Draw", definition: "A hand that needs additional cards to become strong (e.g., flush draw)."),
        PokerTerm(term: "Made Hand", definition: "A complete hand that doesn't need improvement (e.g., current pair or better).")
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(terms) { term in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(term.term)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.black)
                        
                        Text(term.definition)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.black.opacity(0.7))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                }
            }
            .padding()
        }
    }
}

struct StrategyTipsView: View {
    let tips = [
        StrategyTip(
            title: "Play Tight Early",
            tip: "Start with premium hands (high pairs, high suited connectors) especially when learning.",
            icon: "shield.fill"
        ),
        StrategyTip(
            title: "Position Matters",
            tip: "Play more hands when you're in late position. You have more information about opponents' actions.",
            icon: "arrow.right.circle.fill"
        ),
        StrategyTip(
            title: "Consider Pot Odds",
            tip: "Compare the pot size to your bet. If pot odds are favorable, calling can be profitable even with a draw.",
            icon: "percent"
        ),
        StrategyTip(
            title: "Observe Opponents",
            tip: "Pay attention to betting patterns and hand ranges. This helps you make better decisions.",
            icon: "eye.fill"
        ),
        StrategyTip(
            title: "Manage Your Bankroll",
            tip: "Only play with money you can afford to lose. Use proper bankroll management principles.",
            icon: "dollarsign.circle.fill"
        ),
        StrategyTip(
            title: "Review Your Hands",
            tip: "After sessions, analyze key hands. Identify mistakes and areas for improvement.",
            icon: "chart.line.uptrend.xyaxis.fill"
        ),
        StrategyTip(
            title: "Don't Chase Losses",
            tip: "Accept losses as part of the game. Don't try to win back money immediately with risky plays.",
            icon: "exclamationmark.triangle.fill"
        ),
        StrategyTip(
            title: "Know When to Fold",
            tip: "Folding is a powerful tool. Don't be afraid to let go of hands when equity is poor.",
            icon: "hand.raised.fill"
        )
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(tips) { tip in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: tip.icon)
                            .font(.system(size: 24))
                            .foregroundColor(Color(hex: "2DCC72"))
                            .frame(width: 40, height: 40)
                            .background(Color(hex: "2DCC72").opacity(0.1))
                            .cornerRadius(20)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text(tip.title)
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.black)
                            
                            Text(tip.tip)
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.black.opacity(0.7))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                }
            }
            .padding()
        }
    }
}

struct PokerTerm: Identifiable {
    let id = UUID()
    let term: String
    let definition: String
}

struct StrategyTip: Identifiable {
    let id = UUID()
    let title: String
    let tip: String
    let icon: String
}

struct QuickReferenceView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            QuickReferenceView()
        }
    }
}

