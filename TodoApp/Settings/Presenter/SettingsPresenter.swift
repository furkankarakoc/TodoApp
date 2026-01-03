//
//  SettingsPresenter.swift
//  TodoApp
//
//  Created by furkankarakoc on 1.01.2026.
//

import Foundation
import SwiftUI
import Combine

protocol SettingsPresenterProtocol: AnyObject {
    var currentLanguage: AppLanguage { get }
    var currentTheme: AppTheme { get }
    var interactor: SettingsInteractorInputProtocol? { get set }
    
    func viewDidLoad()
    func setLanguage(_ language: AppLanguage)
    func setTheme(_ theme: AppTheme)
}

class SettingsPresenter: ObservableObject, SettingsPresenterProtocol, SettingsInteractorOutputProtocol {
    var interactor: SettingsInteractorInputProtocol?
    
    @Published var currentLanguage: AppLanguage {
        didSet {
            // Force UI update when language changes
            objectWillChange.send()
        }
    }
    @Published var currentTheme: AppTheme = .system
    
    init() {
        // Initialize with current values from manager
        self.currentLanguage = AppLanguageManager.shared.currentLanguage
        self.currentTheme = ThemeManager.shared.currentTheme
    }
    
    func viewDidLoad() {
        currentLanguage = interactor?.getCurrentLanguage() ?? AppLanguageManager.shared.currentLanguage
        currentTheme = interactor?.getCurrentTheme() ?? ThemeManager.shared.currentTheme
    }
    
    func setLanguage(_ language: AppLanguage) {
        interactor?.setLanguage(language)
    }
    
    func setTheme(_ theme: AppTheme) {
        interactor?.setTheme(theme)
    }
    
    // MARK: - SettingsInteractorOutputProtocol
    
    func languageChanged(_ language: AppLanguage) {
        DispatchQueue.main.async {
            self.currentLanguage = language
        }
    }
    
    func themeChanged(_ theme: AppTheme) {
        DispatchQueue.main.async {
            self.currentTheme = theme
        }
    }
}

