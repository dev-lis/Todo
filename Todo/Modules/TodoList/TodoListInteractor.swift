//  
//  TodoListInteractor.swift
//  Todo
//
//  Created by Aleksandr on 15.02.2026.
//
//

import Foundation

protocol ITodoListInteractorInput: AnyObject {
    func fetchTodoList()
}

protocol ITodoListInteractorOutput: AnyObject {
    func didGetTodoList(_ list: [TodoList])
}

final class TodoListInteractor {

    weak var output: ITodoListInteractorOutput?

    private let todoListService: ITodoListService

    init(todoListService: ITodoListService) {
        self.todoListService = todoListService
    }
}

// MARK: - TodoListInteractor

extension TodoListInteractor: ITodoListInteractorInput {
    func fetchTodoList() {
        todoListService.fetchTodoList { [weak self] list in
            self?.output?.didGetTodoList(list)
        }
    }
}
