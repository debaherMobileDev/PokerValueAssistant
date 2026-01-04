//
//  UserPreferences.swift
//  Poker Value Assistant
//
//  Created on 01/04/2026.
//

import Foundation

struct UserPreferences: Codable {
    var hasCompletedOnboarding: Bool = false
    var useSimplifiedLabels: Bool = false
    var preferredColorScheme: String = "system" // "light", "dark", "system"
    
    static let `default` = UserPreferences()
}

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    private let preferencesKey = "userPreferences"
    
    @Published var preferences: UserPreferences {
        didSet {
            savePreferences()
        }
    }
    
    private init() {
        if let data = UserDefaults.standard.data(forKey: preferencesKey),
           let decoded = try? JSONDecoder().decode(UserPreferences.self, from: data) {
            self.preferences = decoded
        } else {
            self.preferences = .default
        }
    }
    
    private func savePreferences() {
        if let encoded = try? JSONEncoder().encode(preferences) {
            UserDefaults.standard.set(encoded, forKey: preferencesKey)
        }
    }
    
    func resetAllData() {
        preferences = .default
        UserDefaults.standard.removeObject(forKey: preferencesKey)
    }
    
    func resetOnboarding() {
        preferences.hasCompletedOnboarding = false
    }
}

