//
//  TodoListView.swift
//  TodoApp
//
//  Created by furkankarakoc on 1.01.2026.
//

import SwiftUI

struct TodoListView: View, TodoViewProtocol {
    @StateObject private var presenter: TodoPresenter
    @State private var showingAddTodo = false
    @State private var selectedTodo: Todo?
    
    init() {
        let presenter = TodoPresenter()
        let interactor = TodoInteractor()
        let router = TodoRouter()
        
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.presenter = presenter
        
        _presenter = StateObject(wrappedValue: presenter)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if presenter.todos.isEmpty {
                    emptyStateView
                } else {
                    todoList
                }
            }
            .navigationTitle("Todo List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddTodo = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddTodo) {
                AddTodoView(presenter: presenter)
            }
            .sheet(item: $selectedTodo) { todo in
                EditTodoView(presenter: presenter, todo: todo)
            }
            .onAppear {
                presenter.viewDidLoad()
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "checklist")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            Text("Henüz todo yok")
                .font(.title2)
                .foregroundColor(.gray)
            Text("Yeni bir todo eklemek için + butonuna tıklayın")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    private var todoList: some View {
        List {
            ForEach(presenter.todos) { todo in
                TodoRowView(todo: todo, presenter: presenter)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            presenter.deleteTodo(todo)
                        } label: {
                            Label("Sil", systemImage: "trash")
                        }
                        
                        Button {
                            selectedTodo = todo
                        } label: {
                            Label("Düzenle", systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
            }
        }
        .listStyle(.insetGrouped)
    }
    
    func updateTodos(_ todos: [Todo]) {
        // SwiftUI will automatically update when @StateObject changes
    }
}

struct TodoRowView: View {
    let todo: Todo
    let presenter: TodoPresenterProtocol
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: {
                presenter.toggleTodoCompletion(todo)
            }) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(todo.isCompleted ? .green : .gray)
                    .font(.title2)
            }
            .buttonStyle(PlainButtonStyle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(todo.title)
                    .font(.headline)
                    .strikethrough(todo.isCompleted)
                    .foregroundColor(todo.isCompleted ? .secondary : .primary)
                
                if !todo.description.isEmpty {
                    Text(todo.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

