//
//  TodoInteractor.swift
//  TodoApp
//
//  Created by furkankarakoc on 1.01.2026.
//

import Foundation

protocol TodoInteractorInputProtocol: AnyObject {
    func fetchTodos()
    func addTodo(title: String, description: String)
    func updateTodo(_ todo: Todo)
    func deleteTodo(_ todo: Todo)
    func toggleTodoCompletion(_ todo: Todo)
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
    
    func addTodo(title: String, description: String) {
        let newTodo = Todo(title: title, description: description)
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
        let updatedTodo = Todo(id: todo.id, title: todo.title, description: todo.description, isCompleted: !todo.isCompleted, createdAt: todo.createdAt)
        updateTodo(updatedTodo)
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
