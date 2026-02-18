//  
//  TodoListPresenter.swift
//  Todo
//
//  Created by Aleksandr Lis on 15.02.2026.
//
//

import AppUIKit

// sourcery: AutoMockable
protocol ITodoListPresenter {
    func viewWillAppear()
    func didChangeSearch(query: String?)
    func didSelectTodo(at index: Int)
    func didTapAddButton()
    func didRequestDeleteTodo(at index: Int)
    func didRequestShareTodo(item: TodoDisplayItem)
}

protocol TodoListModuleOutput: AnyObject {
    func openNewTodoDetail()
    func openTodoDetail(for id: String?)
}

final class TodoListPresenter {

    private var todos = [Todo]()
    private var allItems: [TodoDisplayItem] = []
    private var searchQuery: String = ""

    weak var view: ITodoListView?

    weak var moduleOutput: TodoListModuleOutput?

    private let interactor: ITodoListInteractorInput
    private let router: ITodoListRouter
    private let dateFormatter: IDateFormatter

    init(interactor: ITodoListInteractorInput,
         router: ITodoListRouter,
         dateFormatter: IDateFormatter) {
        self.interactor = interactor
        self.router = router
        self.dateFormatter = dateFormatter
    }

    func handleTodoList(_ todoList: TodoList) {
        todos = todoList.todos.sorted { $0.date > $1.date }
        allItems = todos.enumerated().map { index, todo in
            TodoDisplayItem(
                id: todo.id,
                title: todo.title,
                description: todo.description,
                date: dateFormatter.todoDateString(from: todo.date),
                isCompleted: todo.isCompleted) { [weak self, index] in
                    guard let self else { return }
                    self.todos[index].isCompleted.toggle()
                    self.interactor.updateTodo(self.todos[index])
                }
        }
        applySearchAndUpdateList()
        view?.updateCounter(count: todoList.total)
    }

    private var displayedItems: [TodoDisplayItem] {
        let query = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return allItems }
        let lowercased = query.lowercased()
        return allItems.filter { item in
            item.title.lowercased().contains(lowercased)
            || (item.description?.lowercased().contains(lowercased) ?? false)
        }
    }

    private func applySearchAndUpdateList() {
        view?.updateList(items: displayedItems)
    }
}

// MARK: - ITodoListPresenter

extension TodoListPresenter: ITodoListPresenter {
    func viewWillAppear() {
        interactor.fetchTodoList()
    }

    func didChangeSearch(query: String?) {
        searchQuery = query ?? ""
        applySearchAndUpdateList()
    }

    func didSelectTodo(at index: Int) {
        let items = displayedItems
        guard index >= 0, index < items.count else { return }
        moduleOutput?.openTodoDetail(for: items[index].id)
    }

    func didTapAddButton() {
        moduleOutput?.openNewTodoDetail()
    }

    func didRequestDeleteTodo(at index: Int) {
        let items = displayedItems
        guard index >= 0, index < items.count else { return }
        interactor.deleteTodo(id: items[index].id)
    }

    func didRequestShareTodo(item: TodoDisplayItem) {
        router.shareTodo(item: item)
    }
}

// MARK: - ITodoListInteractorOutput

extension TodoListPresenter: ITodoListInteractorOutput {
    func didGetTodoList(_ list: TodoList) {
        handleTodoList(list)
    }

    func didGetError(_ error: Error) {
        router.showAlert(message: error.localizedDescription)
    }
}
