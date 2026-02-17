//  
//  TodoListPresenter.swift
//  Todo
//
//  Created by Aleksandr Lis on 15.02.2026.
//
//

import AppUIKit

protocol ITodoListPresenter {
    func viewDidLoad()
}

final class TodoListPresenter {

    private var todos = [Todo]()

    weak var view: ITodoListView?

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
        let items = todos.enumerated().map { index, todo in
            TodoDisplayItem(
                id: todo.id,
                title: todo.title,
                description: todo.description,
                date: dateFormatter.todoDateString(from: todo.date),
                isCompleted: todo.isCompleted) { [weak self, index] in
                    self?.todos[index].isCompleted.toggle()
                }
        }
        view?.updateList(items: items)
        view?.updateCounter(count: todoList.total)
    }
}

// MARK: - ITodoListPresenter

extension TodoListPresenter: ITodoListPresenter {
    func viewDidLoad() {
        interactor.fetchTodoList()
    }
}

// MARK: - ITodoListInteractorOutput

extension TodoListPresenter: ITodoListInteractorOutput {
    func didGetTodoList(_ list: TodoList) {
        handleTodoList(list)
    }

    func didGetError(_ error: Error) {
        // TODO: handle error
    }
}
