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
    
    let presenter: TodoPresenterProtocol
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Todo Bilgileri")) {
                    TextField("Başlık", text: $title)
                        .textFieldStyle(.roundedBorder)
                    
                    TextField("Açıklama (Opsiyonel)", text: $description, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Yeni Todo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kaydet") {
                        presenter.addTodo(title: title, description: description)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

