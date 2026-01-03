//
//  TodoInteractor.swift
//  TodoApp
//
//  Created by furkankarakoc on 1.01.2026.
//

import Foundation

protocol TodoInteractorInputProtocol: AnyObject {
    func fetchTodos()
    func addTodo(title: String, description: String, category: TodoCategory, priority: TodoPriority, dueDate: Date?)
    func updateTodo(_ todo: Todo)
    func deleteTodo(_ todo: Todo)
    func toggleTodoCompletion(_ todo: Todo)
    func filterTodos(by category: TodoCategory?, priority: TodoPriority?, showCompleted: Bool, searchText: String) -> [Todo]
    func sortTodos(_ todos: [Todo], by sortOption: TodoSortOption) -> [Todo]
}

protocol TodoInteractorOutputProtocol: AnyObject {
    func todosFetched(_ todos: [Todo])
    func todoAdded(_ todo: Todo)
    func todoUpdated(_ todo: Todo)
    func todoDeleted(_ todo: Todo)
    func errorOccurred(_ error: Error)
}

class TodoInteractor: TodoInteractorInputProtocol {
    weak var presenter: TodoInteractorOutputProtocol?
    
    private var todos: [Todo] = []
    private let todosKey = "SavedTodos"
    
    init() {
        loadTodos()
    }
    
    func fetchTodos() {
        presenter?.todosFetched(todos)
    }
    
    func addTodo(title: String, description: String, category: TodoCategory, priority: TodoPriority, dueDate: Date?) {
        let newTodo = Todo(title: title, description: description, category: category, priority: priority, dueDate: dueDate)
        todos.append(newTodo)
        saveTodos()
        presenter?.todoAdded(newTodo)
    }
    
    func updateTodo(_ todo: Todo) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index] = todo
            saveTodos()
            presenter?.todoUpdated(todo)
        }
    }
    
    func deleteTodo(_ todo: Todo) {
        todos.removeAll { $0.id == todo.id }
        saveTodos()
        presenter?.todoDeleted(todo)
    }
    
    func toggleTodoCompletion(_ todo: Todo) {
        var updatedTodo = todo
        updatedTodo.isCompleted = !todo.isCompleted
        updateTodo(updatedTodo)
    }
    
    func filterTodos(by category: TodoCategory?, priority: TodoPriority?, showCompleted: Bool, searchText: String) -> [Todo] {
        var filtered = todos
        
        // Category filter
        if let category = category {
            filtered = filtered.filter { $0.category == category }
        }
        
        // Priority filter
        if let priority = priority {
            filtered = filtered.filter { $0.priority == priority }
        }
        
        // Completion status filter
        if !showCompleted {
            filtered = filtered.filter { !$0.isCompleted }
        }
        
        // Search filter
        if !searchText.isEmpty {
            filtered = filtered.filter { todo in
                todo.title.localizedCaseInsensitiveContains(searchText) ||
                todo.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered
    }
    
    func sortTodos(_ todos: [Todo], by sortOption: TodoSortOption) -> [Todo] {
        var sorted = todos
        
        switch sortOption {
        case .priority:
            sorted.sort { $0.priority.sortOrder < $1.priority.sortOrder }
        case .dueDate:
            sorted.sort { todo1, todo2 in
                guard let date1 = todo1.dueDate else { return false }
                guard let date2 = todo2.dueDate else { return true }
                return date1 < date2
            }
        case .createdAt:
            sorted.sort { $0.createdAt > $1.createdAt }
        case .title:
            sorted.sort { $0.title.localizedCompare($1.title) == .orderedAscending }
        }
        
        return sorted
    }
    
    // MARK: - Persistence
    
    private func saveTodos() {
        if let encoded = try? JSONEncoder().encode(todos) {
            UserDefaults.standard.set(encoded, forKey: todosKey)
        }
    }
    
    private func loadTodos() {
        if let data = UserDefaults.standard.data(forKey: todosKey),
           let decoded = try? JSONDecoder().decode([Todo].self, from: data) {
            todos = decoded
        }
    }
}
