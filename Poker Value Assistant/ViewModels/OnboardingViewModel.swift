//
//  OnboardingViewModel.swift
//  Poker Value Assistant
//
//  Created on 01/04/2026.
//

import Foundation
import SwiftUI

class OnboardingViewModel: ObservableObject {
    @Published var currentPage: Int = 0
    
    let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Welcome to Poker Value Assistant",
            description: "Your analytical companion for improving poker decision-making. This app helps you evaluate hand strength, calculate equity, and understand hand ranges.",
            icon: "suit.club.fill"
        ),
        OnboardingPage(
            title: "Hand Value Calculator",
            description: "Select your hole cards and community cards to see your hand strength in real-time. The app shows you whether your hand is Strong, Medium, or Weak.",
            icon: "chart.bar.fill"
        ),
        OnboardingPage(
            title: "Equity Estimation",
            description: "Calculate your winning chances against different opponent ranges. Great for post-game analysis and learning optimal play.",
            icon: "percent"
        ),
        OnboardingPage(
            title: "Range Helper",
            description: "Visualize hand ranges and see how your hand compares. Understand which hands you should play in different positions.",
            icon: "square.grid.3x3.fill"
        )
    ]
    
    var isLastPage: Bool {
        currentPage >= pages.count - 1
    }
    
    func nextPage() {
        if currentPage < pages.count - 1 {
            withAnimation {
                currentPage += 1
            }
        }
    }
    
    func previousPage() {
        if currentPage > 0 {
            withAnimation {
                currentPage -= 1
            }
        }
    }
    
    func completeOnboarding() {
        DataManager.shared.preferences.hasCompletedOnboarding = true
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let icon: String
}

