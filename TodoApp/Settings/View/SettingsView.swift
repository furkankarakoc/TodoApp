//
//  SettingsView.swift
//  TodoApp
//
//  Created by furkankarakoc on 1.01.2026.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var presenter: SettingsPresenter
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var languageManager: AppLanguageManager
    
    init() {
        let presenter = SettingsPresenter()
        let interactor = SettingsInteractor()
        
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        _presenter = StateObject(wrappedValue: presenter)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("settings.language".localized)) {
                    Picker("settings.language".localized, selection: Binding(
                        get: { presenter.currentLanguage },
                        set: { presenter.setLanguage($0) }
                    )) {
                        ForEach(AppLanguage.allCases) { language in
                            Text(language.displayName).tag(language)
                        }
                    }
                }
                
                Section(header: Text("settings.appearance".localized)) {
                    Picker("settings.theme".localized, selection: Binding(
                        get: { presenter.currentTheme },
                        set: { presenter.setTheme($0) }
                    )) {
                        Text("settings.theme.system".localized).tag(AppTheme.system)
                        Text("settings.theme.light".localized).tag(AppTheme.light)
                        Text("settings.theme.dark".localized).tag(AppTheme.dark)
                    }
                }
            }
            .navigationTitle("settings.title".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("button.done".localized) {
                        dismiss()
                    }
                }
            }
            .onAppear {
                presenter.viewDidLoad()
            }
            .onChange(of: presenter.currentLanguage) { newLanguage in
                // Force UI refresh when language changes
                languageManager.setLanguage(newLanguage)
            }
            .id(languageManager.currentLanguage.rawValue)
        }
    }
}

