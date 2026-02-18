//  
//  TodoDetailsPresenter.swift
//  Todo
//
//  Created by Aleksandr Lis on 18.02.2026.
//
//

import AppUIKit

protocol ITodoDetailsPresenter {
    func viewDidLoad()
}

final class TodoDetailsPresenter {

    weak var view: ITodoDetailsView?

    private let todoId: Int
    private let interactor: ITodoDetailsInteractorInput
    private let router: ITodoDetailsRouter
    private let dateFormatter: IDateFormatter

    init(todoId: Int,
         interactor: ITodoDetailsInteractorInput,
         router: ITodoDetailsRouter,
         dateFormatter: IDateFormatter) {
        self.todoId = todoId
        self.interactor = interactor
        self.router = router
        self.dateFormatter = dateFormatter
    }
}

// MARK: - ITodoDetailsPresenter

extension TodoDetailsPresenter: ITodoDetailsPresenter {
    func viewDidLoad() {
        interactor.fetchTodo(by: todoId)
    }
}

// MARK: - ITodoDetailsInteractorOutput

extension TodoDetailsPresenter: ITodoDetailsInteractorOutput {
    func didGetTodo(_ todo: Todo) {
        let item = TodoDetailsDisplayItem(
            title: todo.title,
            date: dateFormatter.todoDateString(from: todo.date),
            description: todo.description
        )
        view?.update(item: item)
    }

    func didGetError(_ error: Error) {
        // TODO: handle error router
    }
}
