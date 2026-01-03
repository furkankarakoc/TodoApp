//
//  TodoSortOption.swift
//  TodoApp
//
//  Created by furkankarakoc on 1.01.2026.
//

import Foundation

enum TodoSortOption: String, CaseIterable, Identifiable {
    case priority
    case dueDate
    case createdAt
    case title
    
    var id: String { rawValue }
    
    // Localized display name
    var localizedName: String {
        switch self {
        case .priority: return "sort.priority".localized
        case .dueDate: return "sort.dueDate".localized
        case .createdAt: return "sort.createdAt".localized
        case .title: return "sort.title".localized
        }
    }
}
