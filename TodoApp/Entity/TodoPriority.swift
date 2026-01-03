//
//  TodoPriority.swift
//  TodoApp
//
//  Created by furkankarakoc on 1.01.2026.
//

import Foundation
import SwiftUI

enum TodoPriority: String, Codable, CaseIterable, Identifiable {
    case high
    case medium
    case low
    
    var id: String { rawValue }
    
    // Localized display name
    var localizedName: String {
        switch self {
        case .high: return "priority.high".localized
        case .medium: return "priority.medium".localized
        case .low: return "priority.low".localized
        }
    }
    
    var color: Color {
        switch self {
        case .high:
            return .red
        case .medium:
            return .orange
        case .low:
            return .green
        }
    }
    
    var icon: String {
        switch self {
        case .high:
            return "exclamationmark.triangle.fill"
        case .medium:
            return "exclamationmark.circle.fill"
        case .low:
            return "arrow.down.circle.fill"
        }
    }
    
    var sortOrder: Int {
        switch self {
        case .high: return 0
        case .medium: return 1
        case .low: return 2
        }
    }
}
