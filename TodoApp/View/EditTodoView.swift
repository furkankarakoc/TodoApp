//
//  EditTodoView.swift
//  TodoApp
//
//  Created by furkankarakoc on 1.01.2026.
//

import SwiftUI

struct EditTodoView: View {
    @Environment(\.dismiss) var dismiss
    @State private var title: String
    @State private var description: String
    @State private var isCompleted: Bool
    @State private var selectedCategory: TodoCategory
    @State private var selectedPriority: TodoPriority
    @State private var dueDate: Date?
    @State private var hasDueDate: Bool
    
    let presenter: TodoPresenterProtocol
    let todo: Todo
    
    init(presenter: TodoPresenterProtocol, todo: Todo) {
        self.presenter = presenter
        self.todo = todo
        _title = State(initialValue: todo.title)
        _description = State(initialValue: todo.description)
        _isCompleted = State(initialValue: todo.isCompleted)
        _selectedCategory = State(initialValue: todo.category)
        _selectedPriority = State(initialValue: todo.priority)
        _dueDate = State(initialValue: todo.dueDate)
        _hasDueDate = State(initialValue: todo.dueDate != nil)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("section.todoInfo".localized)) {
                    TextField("todo.title".localized, text: $title)
                        .textFieldStyle(.roundedBorder)
                    
                    TextField("todo.description".localized, text: $description, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(3...6)
                    
                    Toggle("todo.completed".localized, isOn: $isCompleted)
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
            .navigationTitle("todo.edit".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("button.cancel".localized) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("button.save".localized) {
                        let updatedTodo = Todo(
                            id: todo.id,
                            title: title,
                            description: description,
                            isCompleted: isCompleted,
                            createdAt: todo.createdAt,
                            category: selectedCategory,
                            priority: selectedPriority,
                            dueDate: hasDueDate ? dueDate : nil
                        )
                        presenter.updateTodo(updatedTodo)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
