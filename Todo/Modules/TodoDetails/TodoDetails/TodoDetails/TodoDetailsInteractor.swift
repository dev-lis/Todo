//  
//  TodoDetailsInteractor.swift
//  Todo
//
//  Created by Aleksandr Lis on 18.02.2026.
//
//

import Foundation

protocol ITodoDetailsInteractorInput: AnyObject {
    func fetchTodo(by id: Int)
}

protocol ITodoDetailsInteractorOutput: AnyObject {
    func didGetTodo(_ todo: Todo)
    func didGetError(_ error: Error)
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
    func fetchTodo(by id: Int) {
        todoDetailsService.fetchTodo(by: id) { [weak self] result in
            switch result {
            case .success(let todo):
                self?.output?.didGetTodo(todo)
            case .failure(let error):
                self?.output?.didGetError(error)
            }
        }
    }
}
