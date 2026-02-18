//  
//  TodoDetailsInteractor.swift
//  Todo
//
//  Created by Aleksandr Lis on 18.02.2026.
//
//

import Foundation

// sourcery: AutoMockable
protocol ITodoDetailsInteractorInput: AnyObject {
    func fetchTodo(by id: String)
    func saveTodo(_ todo: Todo)
}

// sourcery: AutoMockable
protocol ITodoDetailsInteractorOutput: AnyObject {
    func didGetTodo(_ todo: Todo)
    func didGetError(_ error: Error)
    func didSaveTodo()
}

final class TodoDetailsInteractor {

    weak var output: ITodoDetailsInteractorOutput?

    private let todoDetailsService: ITodoDetailsService

    init(todoDetailsService: ITodoDetailsService) {
        self.todoDetailsService = todoDetailsService
    }
}

// MARK: - TodoDetailsInteractor

extension TodoDetailsInteractor: ITodoDetailsInteractorInput {
    func fetchTodo(by id: String) {
        todoDetailsService.fetchTodo(by: id) { [weak self] result in
            switch result {
            case .success(let todo):
                self?.output?.didGetTodo(todo)
            case .failure(let error):
                self?.output?.didGetError(error)
            }
        }
    }

    func saveTodo(_ todo: Todo) {
        todoDetailsService.saveTodo(todo) { [weak self] result in
            switch result {
            case .success:
                self?.output?.didSaveTodo()
            case .failure(let error):
                self?.output?.didGetError(error)
            }
        }
    }
}
