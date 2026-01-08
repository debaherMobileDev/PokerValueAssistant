//
//  HomeView.swift
//  Poker Value Assistant
//
//  Created on 01/04/2026.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var dataManager = DataManager.shared
    @State private var showOnboarding = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "suit.spade.fill")
                            .font(.system(size: 50))
                            .foregroundColor(Color(hex: "2DCC72"))
                        
                        Text("Poker Value Assistant")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.black)
                        
                        Text("Analyze hands, calculate equity, improve your game")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.black.opacity(0.6))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 32)
                    
                    // Feature cards
                    VStack(spacing: 16) {
                        NavigationLink(destination: HandValueView()) {
                            FeatureCard(
                                icon: "chart.bar.fill",
                                title: "Hand Value Calculator",
                                description: "Evaluate hand strength in real-time",
                                color: Color(hex: "2DCC72")
                            )
                        }
                        
                        NavigationLink(destination: RangeAnalysisView()) {
                            FeatureCard(
                                icon: "square.grid.3x3.fill",
                                title: "Range Helper",
                                description: "Visualize and analyze hand ranges",
                                color: Color(hex: "2DCC72")
                            )
                        }
                        
                        NavigationLink(destination: QuickReferenceView()) {
                            FeatureCard(
                                icon: "book.fill",
                                title: "Quick Reference",
                                description: "Hand rankings and poker terms",
                                color: Color(hex: "2DCC72")
                            )
                        }
                        
                        NavigationLink(destination: SettingsView()) {
                            FeatureCard(
                                icon: "gearshape.fill",
                                title: "Settings",
                                description: "Customize your experience",
                                color: Color.gray
                            )
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 24)
            }
            .navigationBarHidden(true)
            .background(Color.white)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            // Показываем онбординг только при первом запуске покерного приложения
            if !dataManager.preferences.hasCompletedOnboarding {
                showOnboarding = true
            }
        }
        .fullScreenCover(isPresented: $showOnboarding) {
            OnboardingView(isPresented: $showOnboarding)
        }
    }
}

struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(color)
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.black)
                
                Text(description)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.black.opacity(0.6))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.black.opacity(0.3))
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

