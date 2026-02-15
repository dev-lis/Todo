//  
//  TodoListPresenter.swift
//  Todo
//
//  Created by Aleksandr on 15.02.2026.
//
//

import Foundation

protocol ITodoListPresenter {
    func viewDidLoad()
}

final class TodoListPresenter {

    private var todoList = [Todo]()

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

    func handleTodoList() {
        let items = todoList.enumerated().map { index, todo in
            TodoDisplayItem(
                id: todo.id,
                title: todo.title,
                description: todo.description,
                date: dateFormatter.todoDateString(from: todo.date),
                isCompleted: todo.isCompleted) { [weak self, index] in
                    self?.todoList[index].isCompleted.toggle()
                    self?.handleTodoList()
                }
        }
        view?.update(items: items)
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
        self.todoList = list.todos
        handleTodoList()
    }

    func didGetError(_ error: Error) {
        // TODO: handle error
    }
}
