//
//  TodoCategory.swift
//  TodoApp
//
//  Created by furkankarakoc on 1.01.2026.
//

import Foundation
import SwiftUI

enum TodoCategory: String, Codable, CaseIterable, Identifiable {
    case work
    case personal
    case shopping
    case health
    case education
    case other
    
    var id: String { rawValue }
    
    // Localized display name
    var localizedName: String {
        switch self {
        case .work: return "category.work".localized
        case .personal: return "category.personal".localized
        case .shopping: return "category.shopping".localized
        case .health: return "category.health".localized
        case .education: return "category.education".localized
        case .other: return "category.other".localized
        }
    }
    
    var color: Color {
        switch self {
        case .work:
            return .blue
        case .personal:
            return .purple
        case .shopping:
            return .orange
        case .health:
            return .red
        case .education:
            return .green
        case .other:
            return .gray
        }
    }
    
    var icon: String {
        switch self {
        case .work:
            return "briefcase.fill"
        case .personal:
            return "person.fill"
        case .shopping:
            return "cart.fill"
        case .health:
            return "heart.fill"
        case .education:
            return "book.fill"
        case .other:
            return "folder.fill"
        }
    }
}
