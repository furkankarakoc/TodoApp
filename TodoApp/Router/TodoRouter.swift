//
//  TodoRouter.swift
//  TodoApp
//
//  Created by furkankarakoc on 1.01.2026.
//

import SwiftUI

protocol TodoRouterProtocol: AnyObject {
    func presentAddTodoView(from view: TodoViewProtocol?)
    func presentEditTodoView(from view: TodoViewProtocol?, todo: Todo)
}

class TodoRouter: TodoRouterProtocol {
    weak var presenter: TodoPresenterProtocol?
    
    func presentAddTodoView(from view: TodoViewProtocol?) {
        // In SwiftUI, navigation is handled differently
        // This will be handled in the View layer
    }
    
    func presentEditTodoView(from view: TodoViewProtocol?, todo: Todo) {
        // In SwiftUI, navigation is handled differently
        // This will be handled in the View layer
    }
}
