//  
//  TodoListInteractor.swift
//  Todo
//
//  Created by Aleksandr Lis on 15.02.2026.
//
//

import Foundation

protocol ITodoListInteractorInput: AnyObject {
    func fetchTodoList()
    func updateTodo(_ todo: Todo)
}

protocol ITodoListInteractorOutput: AnyObject {
    func didGetTodoList(_ list: TodoList)
    func didGetError(_ error: Error)
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
        todoListService.fetchTodoList { [weak self] result in
            switch result {
            case .success(let list):
                self?.output?.didGetTodoList(list)
            case .failure(let error):
                self?.output?.didGetError(error)
            }
        }
    }

    func updateTodo(_ todo: Todo) {
        todoListService.updateTodo(todo)
    }
}
