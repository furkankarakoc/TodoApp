//
//  TodoPresenter.swift
//  TodoApp
//
//  Created by furkankarakoc on 1.01.2026.
//

import Foundation
import SwiftUI
import Combine

protocol TodoPresenterProtocol: AnyObject {
    var todos: [Todo] { get }
    var router: TodoRouterProtocol? { get set }
    var interactor: TodoInteractorInputProtocol? { get set }
    
    func viewDidLoad()
    func addTodo(title: String, description: String)
    func updateTodo(_ todo: Todo)
    func deleteTodo(_ todo: Todo)
    func toggleTodoCompletion(_ todo: Todo)
    func showAddTodoView()
    func showEditTodoView(_ todo: Todo)
}

class TodoPresenter: ObservableObject, TodoPresenterProtocol, TodoInteractorOutputProtocol {
    var router: TodoRouterProtocol?
    var interactor: TodoInteractorInputProtocol?
    
    @Published var todos: [Todo] = []
    
    func viewDidLoad() {
        interactor?.fetchTodos()
    }
    
    func addTodo(title: String, description: String) {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        interactor?.addTodo(title: title, description: description)
    }
    
    func updateTodo(_ todo: Todo) {
        interactor?.updateTodo(todo)
    }
    
    func deleteTodo(_ todo: Todo) {
        interactor?.deleteTodo(todo)
    }
    
    func toggleTodoCompletion(_ todo: Todo) {
        interactor?.toggleTodoCompletion(todo)
    }
    
    func showAddTodoView() {
        router?.presentAddTodoView(from: nil)
    }
    
    func showEditTodoView(_ todo: Todo) {
        router?.presentEditTodoView(from: nil, todo: todo)
    }
    
    // MARK: - TodoInteractorOutputProtocol
    
    func todosFetched(_ todos: [Todo]) {
        self.todos = todos
    }
    
    func todoAdded(_ todo: Todo) {
        todos.append(todo)
    }
    
    func todoUpdated(_ todo: Todo) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index] = todo
        }
    }
    
    func todoDeleted(_ todo: Todo) {
        todos.removeAll { $0.id == todo.id }
    }
    
    func errorOccurred(_ error: Error) {
        // Handle error - could show alert to user
        print("Error: \(error.localizedDescription)")
    }
}

