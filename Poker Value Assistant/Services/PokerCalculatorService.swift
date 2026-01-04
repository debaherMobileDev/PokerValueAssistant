//
//  PokerCalculatorService.swift
//  Poker Value Assistant
//
//  Created on 01/04/2026.
//

import Foundation

class PokerCalculatorService {
    static let shared = PokerCalculatorService()
    
    private init() {}
    
    // MARK: - Hand Evaluation
    
    func evaluateHand(holeCards: [Card], communityCards: [Card]) -> PokerHand? {
        guard holeCards.count == 2 else { return nil }
        
        let allCards = holeCards + communityCards
        guard allCards.count >= 2 else { return nil }
        
        // If we have 7 cards, find best 5-card combination
        if allCards.count == 7 {
            return findBestHand(from: allCards)
        } else {
            // Evaluate with what we have
            return evaluateCards(allCards)
        }
    }
    
    private func findBestHand(from cards: [Card]) -> PokerHand {
        let combinations = getAllCombinations(of: cards, taking: 5)
        var bestHand: PokerHand?
        
        for combo in combinations {
            let hand = evaluateCards(combo)
            if bestHand == nil || compareHands(hand, bestHand!) > 0 {
                bestHand = hand
            }
        }
        
        return bestHand ?? evaluateCards(Array(cards.prefix(5)))
    }
    
    private func getAllCombinations(of cards: [Card], taking k: Int) -> [[Card]] {
        guard k > 0 && k <= cards.count else { return [] }
        
        if k == 1 {
            return cards.map { [$0] }
        }
        
        var result: [[Card]] = []
        
        for i in 0...(cards.count - k) {
            let head = cards[i]
            let tailCombos = getAllCombinations(of: Array(cards[(i+1)...]), taking: k - 1)
            for combo in tailCombos {
                result.append([head] + combo)
            }
        }
        
        return result
    }
    
    private func evaluateCards(_ cards: [Card]) -> PokerHand {
        let sortedCards = cards.sorted { $0.rank.rawValue > $1.rank.rawValue }
        
        // Check for each hand type in descending order
        if let hand = checkRoyalFlush(sortedCards) { return hand }
        if let hand = checkStraightFlush(sortedCards) { return hand }
        if let hand = checkFourOfAKind(sortedCards) { return hand }
        if let hand = checkFullHouse(sortedCards) { return hand }
        if let hand = checkFlush(sortedCards) { return hand }
        if let hand = checkStraight(sortedCards) { return hand }
        if let hand = checkThreeOfAKind(sortedCards) { return hand }
        if let hand = checkTwoPair(sortedCards) { return hand }
        if let hand = checkOnePair(sortedCards) { return hand }
        
        return checkHighCard(sortedCards)
    }
    
    // MARK: - Hand Checking Functions
    
    private func checkRoyalFlush(_ cards: [Card]) -> PokerHand? {
        guard let straightFlush = checkStraightFlush(cards) else { return nil }
        
        // Check if it's A-K-Q-J-T
        let ranks = cards.map { $0.rank.rawValue }.sorted(by: >)
        if ranks.starts(with: [14, 13, 12, 11, 10]) {
            return PokerHand(cards: cards, ranking: .royalFlush, value: [14])
        }
        
        return nil
    }
    
    private func checkStraightFlush(_ cards: [Card]) -> PokerHand? {
        guard checkFlush(cards) != nil else { return nil }
        guard let straight = checkStraight(cards) else { return nil }
        
        return PokerHand(cards: cards, ranking: .straightFlush, value: straight.value)
    }
    
    private func checkFourOfAKind(_ cards: [Card]) -> PokerHand? {
        let groups = Dictionary(grouping: cards, by: { $0.rank })
        
        if let quad = groups.first(where: { $0.value.count == 4 }) {
            let kicker = cards.filter { $0.rank != quad.key }.max(by: { $0.rank < $1.rank })
            return PokerHand(cards: cards, ranking: .fourOfAKind,
                           value: [quad.key.rawValue, kicker?.rank.rawValue ?? 0])
        }
        
        return nil
    }
    
    private func checkFullHouse(_ cards: [Card]) -> PokerHand? {
        let groups = Dictionary(grouping: cards, by: { $0.rank })
        let trips = groups.filter { $0.value.count == 3 }.keys.sorted(by: { $0.rawValue > $1.rawValue })
        let pairs = groups.filter { $0.value.count >= 2 }.keys.sorted(by: { $0.rawValue > $1.rawValue })
        
        if let tripRank = trips.first {
            if let pairRank = pairs.first(where: { $0 != tripRank }) {
                return PokerHand(cards: cards, ranking: .fullHouse,
                               value: [tripRank.rawValue, pairRank.rawValue])
            }
        }
        
        return nil
    }
    
    private func checkFlush(_ cards: [Card]) -> PokerHand? {
        guard cards.count >= 5 else { return nil }
        
        let suitGroups = Dictionary(grouping: cards, by: { $0.suit })
        
        if let flushSuit = suitGroups.first(where: { $0.value.count >= 5 }) {
            let flushCards = flushSuit.value.sorted { $0.rank.rawValue > $1.rank.rawValue }
            let topFive = Array(flushCards.prefix(5))
            let values = topFive.map { $0.rank.rawValue }
            return PokerHand(cards: topFive, ranking: .flush, value: values)
        }
        
        return nil
    }
    
    private func checkStraight(_ cards: [Card]) -> PokerHand? {
        guard cards.count >= 5 else { return nil }
        
        var uniqueRanks = Array(Set(cards.map { $0.rank })).sorted { $0.rawValue > $1.rawValue }
        
        // Check for wheel (A-2-3-4-5)
        if uniqueRanks.contains(.ace) && uniqueRanks.contains(.five) &&
           uniqueRanks.contains(.four) && uniqueRanks.contains(.three) &&
           uniqueRanks.contains(.two) {
            return PokerHand(cards: cards, ranking: .straight, value: [5]) // Wheel is 5-high
        }
        
        // Check for regular straights
        for i in 0...(uniqueRanks.count - 5) {
            let slice = uniqueRanks[i..<(i+5)]
            let values = slice.map { $0.rawValue }
            
            var isStraight = true
            for j in 0..<4 {
                if values[j] - values[j+1] != 1 {
                    isStraight = false
                    break
                }
            }
            
            if isStraight {
                return PokerHand(cards: cards, ranking: .straight, value: [values[0]])
            }
        }
        
        return nil
    }
    
    private func checkThreeOfAKind(_ cards: [Card]) -> PokerHand? {
        let groups = Dictionary(grouping: cards, by: { $0.rank })
        
        if let trip = groups.first(where: { $0.value.count == 3 }) {
            let kickers = cards.filter { $0.rank != trip.key }
                .sorted { $0.rank.rawValue > $1.rank.rawValue }
                .prefix(2)
                .map { $0.rank.rawValue }
            
            return PokerHand(cards: cards, ranking: .threeOfAKind,
                           value: [trip.key.rawValue] + kickers)
        }
        
        return nil
    }
    
    private func checkTwoPair(_ cards: [Card]) -> PokerHand? {
        let groups = Dictionary(grouping: cards, by: { $0.rank })
        let pairs = groups.filter { $0.value.count == 2 }.keys.sorted { $0.rawValue > $1.rawValue }
        
        if pairs.count >= 2 {
            let topPairs = Array(pairs.prefix(2))
            let kicker = cards.filter { !topPairs.contains($0.rank) }
                .max(by: { $0.rank < $1.rank })
            
            return PokerHand(cards: cards, ranking: .twoPair,
                           value: [topPairs[0].rawValue, topPairs[1].rawValue, kicker?.rank.rawValue ?? 0])
        }
        
        return nil
    }
    
    private func checkOnePair(_ cards: [Card]) -> PokerHand? {
        let groups = Dictionary(grouping: cards, by: { $0.rank })
        
        if let pair = groups.first(where: { $0.value.count == 2 }) {
            let kickers = cards.filter { $0.rank != pair.key }
                .sorted { $0.rank.rawValue > $1.rank.rawValue }
                .prefix(3)
                .map { $0.rank.rawValue }
            
            return PokerHand(cards: cards, ranking: .onePair,
                           value: [pair.key.rawValue] + kickers)
        }
        
        return nil
    }
    
    private func checkHighCard(_ cards: [Card]) -> PokerHand {
        let sortedValues = cards.sorted { $0.rank.rawValue > $1.rank.rawValue }
            .prefix(5)
            .map { $0.rank.rawValue }
        
        return PokerHand(cards: cards, ranking: .highCard, value: sortedValues)
    }
    
    // MARK: - Hand Comparison
    
    private func compareHands(_ hand1: PokerHand, _ hand2: PokerHand) -> Int {
        if hand1.ranking.rawValue > hand2.ranking.rawValue { return 1 }
        if hand1.ranking.rawValue < hand2.ranking.rawValue { return -1 }
        
        // Same ranking, compare values
        for i in 0..<min(hand1.value.count, hand2.value.count) {
            if hand1.value[i] > hand2.value[i] { return 1 }
            if hand1.value[i] < hand2.value[i] { return -1 }
        }
        
        return 0
    }
    
    // MARK: - Equity Calculation
    
    func calculateEquity(holeCards: [Card], communityCards: [Card], against range: HandRange, iterations: Int = 1000) -> Double {
        guard holeCards.count == 2 else { return 0.0 }
        
        var wins = 0
        var ties = 0
        
        let usedCards = Set(holeCards + communityCards)
        var availableDeck = Card.deck().filter { !usedCards.contains($0) }
        
        for _ in 0..<iterations {
            availableDeck.shuffle()
            
            // Complete the board if needed
            var board = communityCards
            let cardsNeeded = 5 - communityCards.count
            
            // Check if we have enough cards
            guard availableDeck.count >= cardsNeeded + 2 else {
                continue
            }
            
            if cardsNeeded > 0 {
                board += Array(availableDeck.prefix(cardsNeeded))
            }
            
            // Deal opponent cards
            let opponentStartIndex = cardsNeeded
            let opponentEndIndex = opponentStartIndex + 2
            guard opponentEndIndex <= availableDeck.count else {
                continue
            }
            let opponentCards = Array(availableDeck[opponentStartIndex..<opponentEndIndex])
            
            // Evaluate both hands
            guard let heroHand = evaluateHand(holeCards: holeCards, communityCards: board),
                  let villainHand = evaluateHand(holeCards: opponentCards, communityCards: board) else {
                continue
            }
            
            let comparison = compareHands(heroHand, villainHand)
            if comparison > 0 {
                wins += 1
            } else if comparison == 0 {
                ties += 1
            }
        }
        
        let equity = (Double(wins) + Double(ties) * 0.5) / Double(iterations)
        return equity * 100.0
    }
    
    func estimateEquityAgainstRandom(holeCards: [Card], communityCards: [Card]) -> Double {
        return calculateEquity(holeCards: holeCards, communityCards: communityCards, against: .loose, iterations: 500)
    }
}

