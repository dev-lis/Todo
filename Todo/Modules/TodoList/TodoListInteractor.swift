//
//  TodoListInteractorInteractor.swift
//  Todo
//
//  
//  TodoListInteractor.swift
//  Todo
//
//  Created by Aleksandr on 15.02.2026.
//
//

import Foundation

protocol ITodoListInteractorInput: AnyObject {}

protocol ITodoListInteractorOutput: AnyObject {}

final class TodoListInteractor {

    weak var output: ITodoListInteractorOutput?
}

// MARK: - TodoListInteractor

extension TodoListInteractor: ITodoListInteractorInput {

}
