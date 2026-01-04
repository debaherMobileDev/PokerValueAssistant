//
//  RangeAnalysisView.swift
//  Poker Value Assistant
//
//  Created on 01/04/2026.
//

import SwiftUI

struct RangeAnalysisView: View {
    @StateObject private var viewModel = RangeViewModel()
    @State private var showingCardSelector = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Selected Cards Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Your Hole Cards")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.black)
                    
                    HStack(spacing: 12) {
                        ForEach(viewModel.selectedHoleCards) { card in
                            CardView(card: card, size: .large, isSelected: true)
                                .onTapGesture {
                                    viewModel.removeCard(card)
                                }
                        }
                        
                        if viewModel.selectedHoleCards.count < 2 {
                            Button(action: {
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
                        } else {
                            Button(action: {
                                viewModel.clearSelection()
                            }) {
                                Text("Clear")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(.red)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(Color.red.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                    }
                    
                    if viewModel.selectedHoleCards.count == 2 {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Hand Notation: \(viewModel.holeCardsNotation)")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.black.opacity(0.7))
                            
                            HStack {
                                Text("In Range:")
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(.black.opacity(0.7))
                                
                                Text(viewModel.isInSelectedRange ? "Yes" : "No")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(viewModel.isInSelectedRange ? Color(hex: "2DCC72") : .red)
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                
                // Range Selector
                VStack(alignment: .leading, spacing: 12) {
                    Text("Opponent Range")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Picker("Range", selection: $viewModel.selectedRange) {
                        ForEach(HandRange.allRanges, id: \.name) { range in
                            Text(range.name).tag(range)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Text("\(viewModel.selectedRange.hands.count) hand combinations")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.black.opacity(0.5))
                }
                .padding(.horizontal, 24)
                
                // Highlight Mode
                if viewModel.selectedHoleCards.count == 2 {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Highlight Mode")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.black)
                        
                        Picker("Mode", selection: $viewModel.highlightMode) {
                            ForEach(RangeHighlightMode.allCases, id: \.self) { mode in
                                Text(mode.rawValue).tag(mode)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    .padding(.horizontal, 24)
                }
                
                // Range Grid
                VStack(alignment: .leading, spacing: 12) {
                    Text("Hand Range Matrix")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.black)
                        .padding(.horizontal, 24)
                    
                    RangeMatrixView(viewModel: viewModel)
                        .padding(.horizontal, 12)
                }
                
                // Legend
                VStack(alignment: .leading, spacing: 8) {
                    Text("Legend")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.black)
                    
                    HStack(spacing: 16) {
                        LegendItem(color: Color(hex: "2DCC72").opacity(0.3), label: "In Range")
                        LegendItem(color: Color.yellow.opacity(0.3), label: "Highlighted")
                        LegendItem(color: Color.gray.opacity(0.1), label: "Not in Range")
                    }
                }
                .padding(.horizontal, 24)
            }
            .padding(.vertical, 24)
        }
        .navigationTitle("Range Analysis")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(UIColor.systemGroupedBackground))
        .sheet(isPresented: $showingCardSelector) {
            NavigationView {
                CardSelectorView(availableCards: Card.deck().filter { card in
                    !viewModel.selectedHoleCards.contains(card)
                }) { card in
                    viewModel.selectCard(card)
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
}

struct RangeMatrixView: View {
    @ObservedObject var viewModel: RangeViewModel
    
    let ranks = ["A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2"]
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 2), count: 13), spacing: 2) {
            ForEach(0..<169, id: \.self) { index in
                let row = index / 13
                let col = index % 13
                let handNotation = getHandNotation(row: row, col: col)
                
                RangeCell(
                    notation: handNotation,
                    isInRange: viewModel.selectedRange.hands.contains(handNotation),
                    isHighlighted: viewModel.shouldHighlight(handNotation)
                )
            }
        }
    }
    
    private func getHandNotation(row: Int, col: Int) -> String {
        let rank1 = ranks[row]
        let rank2 = ranks[col]
        
        if row == col {
            // Pocket pairs
            return "\(rank1)\(rank2)"
        } else if row < col {
            // Suited
            return "\(rank2)\(rank1)s"
        } else {
            // Offsuit
            return "\(rank1)\(rank2)o"
        }
    }
}

struct RangeCell: View {
    let notation: String
    let isInRange: Bool
    let isHighlighted: Bool
    
    var body: some View {
        Text(notation)
            .font(.system(size: 10, weight: .medium))
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .background(backgroundColor)
            .cornerRadius(4)
    }
    
    private var backgroundColor: Color {
        if isHighlighted {
            return Color.yellow.opacity(0.3)
        } else if isInRange {
            return Color(hex: "2DCC72").opacity(0.3)
        } else {
            return Color.gray.opacity(0.1)
        }
    }
}

struct LegendItem: View {
    let color: Color
    let label: String
    
    var body: some View {
        HStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 3)
                .fill(color)
                .frame(width: 20, height: 20)
            
            Text(label)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.black.opacity(0.7))
        }
    }
}

struct RangeAnalysisView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RangeAnalysisView()
        }
    }
}

