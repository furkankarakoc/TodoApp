//
//  AddTodoView.swift
//  TodoApp
//
//  Created by furkankarakoc on 1.01.2026.
//

import SwiftUI

struct AddTodoView: View {
    @Environment(\.dismiss) var dismiss
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var selectedCategory: TodoCategory = .other
    @State private var selectedPriority: TodoPriority = .medium
    @State private var dueDate: Date?
    @State private var hasDueDate: Bool = false
    
    let presenter: TodoPresenterProtocol
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("section.todoInfo".localized)) {
                    TextField("todo.title".localized, text: $title)
                        .textFieldStyle(.roundedBorder)
                    
                    TextField("todo.description.optional".localized, text: $description, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(3...6)
                }
                
                Section(header: Text("section.category".localized)) {
                    Picker("todo.category".localized, selection: $selectedCategory) {
                        ForEach(TodoCategory.allCases) { category in
                            HStack {
                                Image(systemName: category.icon)
                                    .foregroundColor(category.color)
                                Text(category.localizedName)
                            }
                            .tag(category)
                        }
                    }
                }
                
                Section(header: Text("section.priority".localized)) {
                    Picker("todo.priority".localized, selection: $selectedPriority) {
                        ForEach(TodoPriority.allCases) { priority in
                            HStack {
                                Image(systemName: priority.icon)
                                    .foregroundColor(priority.color)
                                Text(priority.localizedName)
                            }
                            .tag(priority)
                        }
                    }
                }
                
                Section(header: Text("section.date".localized)) {
                    Toggle("todo.dueDate.add".localized, isOn: $hasDueDate)
                    
                    if hasDueDate {
                        DatePicker("todo.dueDate".localized, selection: Binding(
                            get: { dueDate ?? Date() },
                            set: { dueDate = $0 }
                        ), displayedComponents: [.date, .hourAndMinute])
                    }
                }
            }
            .navigationTitle("todo.new".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("button.cancel".localized) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("button.save".localized) {
                        presenter.addTodo(
                            title: title,
                            description: description,
                            category: selectedCategory,
                            priority: selectedPriority,
                            dueDate: hasDueDate ? dueDate : nil
                        )
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
