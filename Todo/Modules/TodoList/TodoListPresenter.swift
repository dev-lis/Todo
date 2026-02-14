//
//  TodoListPresenterPresenter.swift
//  Todo
//
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

    private var todoList = [TodoList]()

    weak var view: ITodoListView?

    private var interactor: ITodoListInteractorInput?
    private var router: ITodoListRouter?

    init(interactor: ITodoListInteractorInput,
         router: ITodoListRouter) {
        self.interactor = interactor
        self.router = router
    }

    func handleTodoList() {
        let items = todoList.enumerated().map { index, todo in
            TodoDisplayItem(
                id: todo.id,
                title: todo.title,
                description: todo.description,
                date: "",
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
        interactor?.fetchTodoList()
    }
}

// MARK: - ITodoListInteractorOutput

extension TodoListPresenter: ITodoListInteractorOutput {
    func didGetTodoList(_ list: [TodoList]) {
        self.todoList = list
        handleTodoList()
    }
}
