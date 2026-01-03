//
//  TodoAppApp.swift
//  TodoApp
//
//  Created by furkankarakoc on 1.01.2026.
//

import SwiftUI

@main
struct TodoAppApp: App {
    @StateObject private var themeManager = ThemeManager.shared
    @StateObject private var languageManager = AppLanguageManager.shared
    
    var body: some Scene {
        WindowGroup {
            TodoListView()
                .preferredColorScheme(themeManager.currentTheme.colorScheme)
                .environmentObject(themeManager)
                .environmentObject(languageManager)
                .id(languageManager.currentLanguage.rawValue)
        }
    }
}
