//
//  AppLanguageManager.swift
//  TodoApp
//
//  Created by furkankarakoc on 1.01.2026.
//

import Foundation
import SwiftUI
import Combine
import ObjectiveC

enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "en"
    case turkish = "tr"
    case french = "fr"
    case german = "de"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .english: return "English"
        case .turkish: return "Türkçe"
        case .french: return "Français"
        case .german: return "Deutsch"
        }
    }
    
    var locale: Locale {
        Locale(identifier: rawValue)
    }
}

class AppLanguageManager: ObservableObject {
    static let shared = AppLanguageManager()
    
    @Published var currentLanguage: AppLanguage {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: "AppLanguage")
            Bundle.setLanguage(currentLanguage.rawValue)
            // Force UI update
            NotificationCenter.default.post(name: NSNotification.Name("LanguageChanged"), object: nil)
        }
    }
    
    private init() {
        let savedLanguage = UserDefaults.standard.string(forKey: "AppLanguage") ?? "en"
        self.currentLanguage = AppLanguage(rawValue: savedLanguage) ?? .english
        Bundle.setLanguage(currentLanguage.rawValue)
    }
    
    func setLanguage(_ language: AppLanguage) {
        currentLanguage = language
    }
}

extension Bundle {
    fileprivate static var bundle: Bundle!
    
    static func setLanguage(_ language: String) {
        defer {
            object_setClass(Bundle.main, AnyLanguageBundle.self)
        }
        objc_setAssociatedObject(Bundle.main, &bundle, Bundle.main.path(forResource: language, ofType: "lproj").flatMap(Bundle.init(path:)), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    static var localizedBundle: Bundle {
        if let path = objc_getAssociatedObject(Bundle.main, &bundle) as? String, let bundle = Bundle(path: path) {
            return bundle
        }
        return Bundle.main
    }
}

private class AnyLanguageBundle: Bundle, @unchecked Sendable {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        guard let path = objc_getAssociatedObject(self, &Bundle.bundle) as? String,
              let bundle = Bundle(path: path) else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
}

extension String {
    var localized: String {
        return Bundle.localizedBundle.localizedString(forKey: self, value: nil, table: nil)
    }
}

