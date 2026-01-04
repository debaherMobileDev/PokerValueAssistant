//
//  Poker_Value_AssistantApp.swift
//  Poker Value Assistant
//
//  Created by Simon Bakhanets on 04.01.2026.
//

import SwiftUI

@main
struct Poker_Value_AssistantApp: App {
    @StateObject private var dataManager = DataManager.shared
    @State private var showOnboarding = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    showOnboarding = !dataManager.preferences.hasCompletedOnboarding
                }
                .fullScreenCover(isPresented: $showOnboarding) {
                    OnboardingView(isPresented: $showOnboarding)
                }
        }
    }
}
