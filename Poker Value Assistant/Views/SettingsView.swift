//
//  SettingsView.swift
//  Poker Value Assistant
//
//  Created on 01/04/2026.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject private var dataManager = DataManager.shared
    @State private var showingResetAlert = false
    @State private var showingDeleteAlert = false
    @State private var showingOnboarding = false
    
    var body: some View {
        Form {
            Section(header: Text("Appearance")) {
                Toggle("Simplified Hand Labels", isOn: $dataManager.preferences.useSimplifiedLabels)
                    .tint(Color(hex: "2DCC72"))
            }
            
            Section(header: Text("Onboarding")) {
                Button(action: {
                    dataManager.resetOnboarding()
                    showingOnboarding = true
                }) {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                            .foregroundColor(Color(hex: "2DCC72"))
                        Text("Show Onboarding Again")
                            .foregroundColor(.black)
                    }
                }
            }
            
            Section(header: Text("Data Management")) {
                Button(action: {
                    showingDeleteAlert = true
                }) {
                    HStack {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                        Text("Delete All Data")
                            .foregroundColor(.red)
                    }
                }
            }
            
            Section(header: Text("About")) {
                HStack {
                    Text("Version")
                        .foregroundColor(.black)
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.black.opacity(0.5))
                }
                
                HStack {
                    Text("App Type")
                        .foregroundColor(.black)
                    Spacer()
                    Text("Educational Utility")
                        .foregroundColor(.black.opacity(0.5))
                        .multilineTextAlignment(.trailing)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Disclaimer")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text("This app is for educational and analytical purposes only. It does not involve real money gambling or betting.")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.black.opacity(0.6))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showingDeleteAlert) {
            Alert(
                title: Text("Delete All Data"),
                message: Text("This will reset all preferences and data. This action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    dataManager.resetAllData()
                },
                secondaryButton: .cancel()
            )
        }
        .fullScreenCover(isPresented: $showingOnboarding) {
            OnboardingView(isPresented: $showingOnboarding)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
        }
    }
}

