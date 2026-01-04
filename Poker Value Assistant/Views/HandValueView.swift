//
//  HandValueView.swift
//  Poker Value Assistant
//
//  Created on 01/04/2026.
//

import SwiftUI

struct HandValueView: View {
    @StateObject private var viewModel = HandValueViewModel()
    @State private var showingCardSelector = false
    @State private var currentSelectionType: CardSelectionType = .hole
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Hole Cards Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Your Hole Cards")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.black)
                    
                    HStack(spacing: 12) {
                        ForEach(viewModel.selectedHoleCards) { card in
                            CardView(card: card, size: .large, isSelected: true)
                                .onTapGesture {
                                    viewModel.removeCard(card, from: .hole)
                                }
                        }
                        
                        if viewModel.canAddHoleCard {
                            Button(action: {
                                currentSelectionType = .hole
                                showingCardSelector = true
                            }) {
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color(hex: "2DCC72"), style: StrokeStyle(lineWidth: 2, dash: [5]))
                                    .frame(width: 70, height: 98)
                                    .overlay(
                                        Image(systemName: "plus")
                                            .font(.system(size: 24))
                                            .foregroundColor(Color(hex: "2DCC72"))
                                    )
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                
                // Community Cards Section
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Community Cards")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        if !viewModel.selectedCommunityCards.isEmpty {
                            Button(action: {
                                viewModel.clearCommunityCards()
                            }) {
                                Text("Clear")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(Color(hex: "2DCC72"))
                            }
                        }
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(viewModel.selectedCommunityCards) { card in
                                CardView(card: card, size: .large, isSelected: true)
                                    .onTapGesture {
                                        viewModel.removeCard(card, from: .community)
                                    }
                            }
                            
                            if viewModel.canAddCommunityCard {
                                Button(action: {
                                    currentSelectionType = .community
                                    showingCardSelector = true
                                }) {
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color(hex: "2DCC72"), style: StrokeStyle(lineWidth: 2, dash: [5]))
                                        .frame(width: 70, height: 98)
                                        .overlay(
                                            Image(systemName: "plus")
                                                .font(.system(size: 24))
                                                .foregroundColor(Color(hex: "2DCC72"))
                                        )
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                
                // Hand Evaluation
                if let hand = viewModel.currentHand {
                    VStack(spacing: 16) {
                        VStack(spacing: 8) {
                            Text(hand.ranking.displayName)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.black)
                            
                            Text(hand.ranking.description)
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.black.opacity(0.6))
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(12)
                        
                        // Hand Strength
                        HStack {
                            Text("Strength:")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            Text(hand.strengthLevel.rawValue)
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(strengthColor(hand.strengthLevel))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(strengthColor(hand.strengthLevel).opacity(0.1))
                                .cornerRadius(8)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                        
                        // Equity Calculator
                        VStack(spacing: 12) {
                            HStack {
                                Text("Equity Calculator")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.black)
                                
                                Spacer()
                            }
                            
                            Picker("Range", selection: $viewModel.selectedRange) {
                                ForEach(HandRange.allRanges, id: \.name) { range in
                                    Text(range.name).tag(range)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            Button(action: {
                                viewModel.calculateEquity()
                            }) {
                                HStack {
                                    if viewModel.isCalculatingEquity {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    } else {
                                        Text("Calculate Equity")
                                            .font(.system(size: 17, weight: .semibold))
                                    }
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(hex: "2DCC72"))
                                .cornerRadius(12)
                            }
                            .disabled(viewModel.isCalculatingEquity)
                            
                            if viewModel.equity > 0 {
                                HStack {
                                    Text("Win Probability:")
                                        .font(.system(size: 15, weight: .regular))
                                        .foregroundColor(.black.opacity(0.7))
                                    
                                    Spacer()
                                    
                                    Text(String(format: "%.1f%%", viewModel.equity))
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(Color(hex: "2DCC72"))
                                }
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                    }
                    .padding(.horizontal, 24)
                }
                
                // Clear All button
                if !viewModel.selectedHoleCards.isEmpty || !viewModel.selectedCommunityCards.isEmpty {
                    Button(action: {
                        viewModel.clearAllCards()
                    }) {
                        Text("Clear All Cards")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.05))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 24)
                }
            }
            .padding(.vertical, 24)
        }
        .navigationTitle("Hand Value")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(UIColor.systemGroupedBackground))
        .sheet(isPresented: $showingCardSelector) {
            NavigationView {
                CardSelectorView(availableCards: viewModel.availableCards) { card in
                    viewModel.selectCard(card, for: currentSelectionType)
                    showingCardSelector = false
                }
                .navigationTitle("Select Card")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: Button("Done") {
                    showingCardSelector = false
                })
            }
        }
    }
    
    private func strengthColor(_ strength: HandStrength) -> Color {
        switch strength {
        case .strong:
            return Color(hex: "2DCC72")
        case .medium:
            return .orange
        case .weak:
            return .red
        }
    }
}

struct HandValueView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HandValueView()
        }
    }
}

