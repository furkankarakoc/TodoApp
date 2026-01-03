//
//  ThemeManager.swift
//  TodoApp
//
//  Created by furkankarakoc on 1.01.2026.
//

import SwiftUI
import Combine

enum AppTheme: String, CaseIterable {
    case system
    case light
    case dark
    
    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @Published var currentTheme: AppTheme {
        didSet {
            UserDefaults.standard.set(currentTheme.rawValue, forKey: "AppTheme")
        }
    }
    
    private init() {
        let savedTheme = UserDefaults.standard.string(forKey: "AppTheme") ?? "system"
        self.currentTheme = AppTheme(rawValue: savedTheme) ?? .system
    }
    
    func setTheme(_ theme: AppTheme) {
        currentTheme = theme
    }
}

