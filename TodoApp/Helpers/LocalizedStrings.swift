//
//  LocalizedStrings.swift
//  TodoApp
//
//  Created by furkankarakoc on 1.01.2026.
//

import Foundation

// Localization helper
extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

