//
//  SettingsInteractor.swift
//  TodoApp
//
//  Created by furkankarakoc on 1.01.2026.
//

import Foundation

protocol SettingsInteractorInputProtocol: AnyObject {
    func getCurrentLanguage() -> AppLanguage
    func setLanguage(_ language: AppLanguage)
    func getCurrentTheme() -> AppTheme
    func setTheme(_ theme: AppTheme)
}

protocol SettingsInteractorOutputProtocol: AnyObject {
    func languageChanged(_ language: AppLanguage)
    func themeChanged(_ theme: AppTheme)
}

class SettingsInteractor: SettingsInteractorInputProtocol {
    weak var presenter: SettingsInteractorOutputProtocol?
    
    func getCurrentLanguage() -> AppLanguage {
        return AppLanguageManager.shared.currentLanguage
    }
    
    func setLanguage(_ language: AppLanguage) {
        AppLanguageManager.shared.setLanguage(language)
        presenter?.languageChanged(language)
    }
    
    func getCurrentTheme() -> AppTheme {
        return ThemeManager.shared.currentTheme
    }
    
    func setTheme(_ theme: AppTheme) {
        ThemeManager.shared.setTheme(theme)
        presenter?.themeChanged(theme)
    }
}

