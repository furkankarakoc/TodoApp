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
    
    let presenter: TodoPresenterProtocol
    let todo: Todo
    
    init(presenter: TodoPresenterProtocol, todo: Todo) {
        self.presenter = presenter
        self.todo = todo
        _title = State(initialValue: todo.title)
        _description = State(initialValue: todo.description)
        _isCompleted = State(initialValue: todo.isCompleted)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Todo Bilgileri")) {
                    TextField("Başlık", text: $title)
                        .textFieldStyle(.roundedBorder)
                    
                    TextField("Açıklama", text: $description, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(3...6)
                    
                    Toggle("Tamamlandı", isOn: $isCompleted)
                }
            }
            .navigationTitle("Todo Düzenle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kaydet") {
                        let updatedTodo = Todo(
                            id: todo.id,
                            title: title,
                            description: description,
                            isCompleted: isCompleted,
                            createdAt: todo.createdAt
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

