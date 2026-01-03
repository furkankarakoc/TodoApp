//
//  TodoListView.swift
//  TodoApp
//
//  Created by furkankarakoc on 1.01.2026.
//

import SwiftUI
import Combine

struct TodoListView: View, TodoViewProtocol {
    @StateObject private var presenter: TodoPresenter
    @EnvironmentObject var languageManager: AppLanguageManager
    @State private var showingAddTodo = false
    @State private var selectedTodo: Todo?
    @State private var selectedCategory: TodoCategory? = nil
    @State private var selectedPriority: TodoPriority? = nil
    @State private var showCompleted: Bool = true
    @State private var searchText: String = ""
    @State private var sortOption: TodoSortOption = .priority
    @State private var showingFilters: Bool = false
    @State private var showingSettings: Bool = false
    
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
    
    // Performance: Computed property (caching handled in Interactor)
    var filteredAndSortedTodos: [Todo] {
        presenter.getFilteredAndSortedTodos(
            category: selectedCategory,
            priority: selectedPriority,
            showCompleted: showCompleted,
            searchText: searchText,
            sortOption: sortOption
        )
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if filteredAndSortedTodos.isEmpty {
                    emptyStateView
                } else {
                    todoList
                }
            }
            .navigationTitle("app.title".localized)
            .searchable(text: $searchText, prompt: "search.placeholder".localized)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Button(action: {
                            showingFilters.toggle()
                        }) {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .font(.title2)
                        }
                        
                        Button(action: {
                            showingSettings.toggle()
                        }) {
                            Image(systemName: "gearshape.fill")
                                .font(.title2)
                        }
                    }
                }
                
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
            .sheet(isPresented: $showingFilters) {
                FilterView(
                    selectedCategory: $selectedCategory,
                    selectedPriority: $selectedPriority,
                    showCompleted: $showCompleted,
                    sortOption: $sortOption
                )
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
                    .environmentObject(languageManager)
            }
            .onAppear {
                presenter.viewDidLoad()
            }
            .id(languageManager.currentLanguage.rawValue)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "checklist")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            Text("empty.title".localized)
                .font(.title2)
                .foregroundColor(.gray)
            Text("empty.message".localized)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    private var todoList: some View {
        List {
            ForEach(filteredAndSortedTodos) { todo in
                TodoRowView(todo: todo, presenter: presenter)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            presenter.deleteTodo(todo)
                        } label: {
                            Label("button.delete".localized, systemImage: "trash")
                        }
                        
                        Button {
                            selectedTodo = todo
                        } label: {
                            Label("button.edit".localized, systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
            }
        }
        .listStyle(.insetGrouped)
    }
    
    func updateTodos(_ todos: [Todo]) {
        // Auto-update via @StateObject
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
            
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    // Category icon
                    Image(systemName: todo.category.icon)
                        .foregroundColor(todo.category.color)
                        .font(.caption)
                    
                    // Priority icon
                    Image(systemName: todo.priority.icon)
                        .foregroundColor(todo.priority.color)
                        .font(.caption)
                    
                    Spacer()
                    
                    // Due date warning
                    if todo.dueDate != nil {
                        if todo.isOverdue {
                            Label("status.overdue".localized, systemImage: "exclamationmark.triangle.fill")
                                .font(.caption2)
                                .foregroundColor(.red)
                        } else if todo.isDueSoon {
                            Label("status.dueSoon".localized, systemImage: "clock.fill")
                                .font(.caption2)
                                .foregroundColor(.orange)
                        }
                    }
                }
                
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
                
                if let dueDate = todo.dueDate {
                    HStack {
                        Image(systemName: "calendar")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text(dueDate, style: .date)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text("•")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text(dueDate, style: .time)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 6)
        .opacity(todo.isCompleted ? 0.6 : 1.0)
    }
}

struct FilterView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedCategory: TodoCategory?
    @Binding var selectedPriority: TodoPriority?
    @Binding var showCompleted: Bool
    @Binding var sortOption: TodoSortOption
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("filter.category".localized)) {
                    Picker("todo.category".localized, selection: Binding(
                        get: { selectedCategory ?? .other },
                        set: { selectedCategory = $0 == .other ? nil : $0 }
                    )) {
                        Text("filter.all".localized).tag(TodoCategory.other)
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
                
                Section(header: Text("filter.priority".localized)) {
                    Picker("todo.priority".localized, selection: Binding(
                        get: { selectedPriority ?? .medium },
                        set: { selectedPriority = $0 == .medium ? nil : $0 }
                    )) {
                        Text("filter.all".localized).tag(TodoPriority.medium)
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
                
                Section(header: Text("section.view".localized)) {
                    Toggle("filter.showCompleted".localized, isOn: $showCompleted)
                }
                
                Section(header: Text("section.sort".localized)) {
                    Picker("section.sort".localized, selection: $sortOption) {
                        ForEach(TodoSortOption.allCases) { option in
                            Text(option.localizedName).tag(option)
                        }
                    }
                }
            }
            .navigationTitle("filters.title".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("button.done".localized) {
                        dismiss()
                    }
                }
            }
        }
    }
}
