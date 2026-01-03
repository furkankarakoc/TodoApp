//
//  Todo.swift
//  TodoApp
//
//  Created by furkankarakoc on 1.01.2026.
//

import Foundation

struct Todo: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var isCompleted: Bool
    var createdAt: Date
    var category: TodoCategory
    var priority: TodoPriority
    var dueDate: Date?
    
    init(id: UUID = UUID(), 
         title: String, 
         description: String = "", 
         isCompleted: Bool = false, 
         createdAt: Date = Date(),
         category: TodoCategory = .other,
         priority: TodoPriority = .medium,
         dueDate: Date? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.category = category
        self.priority = priority
        self.dueDate = dueDate
    }
    
    var isOverdue: Bool {
        guard let dueDate = dueDate, !isCompleted else { return false }
        return dueDate < Date()
    }
    
    var isDueSoon: Bool {
        guard let dueDate = dueDate, !isCompleted else { return false }
        let daysUntilDue = Calendar.current.dateComponents([.day], from: Date(), to: dueDate).day ?? 0
        return daysUntilDue >= 0 && daysUntilDue <= 3
    }
}
