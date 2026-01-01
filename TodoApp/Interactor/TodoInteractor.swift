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
    
    func fetchTodos() {
        // Simulated data storage - in a real app, this would fetch from a database or API
        presenter?.todosFetched(todos)
    }
    
    func addTodo(title: String, description: String) {
        let newTodo = Todo(title: title, description: description)
        todos.append(newTodo)
        presenter?.todoAdded(newTodo)
    }
    
    func updateTodo(_ todo: Todo) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index] = todo
            presenter?.todoUpdated(todo)
        }
    }
    
    func deleteTodo(_ todo: Todo) {
        todos.removeAll { $0.id == todo.id }
        presenter?.todoDeleted(todo)
    }
    
    func toggleTodoCompletion(_ todo: Todo) {
        let updatedTodo = Todo(id: todo.id, title: todo.title, description: todo.description, isCompleted: !todo.isCompleted, createdAt: todo.createdAt)
        updateTodo(updatedTodo)
    }
}

