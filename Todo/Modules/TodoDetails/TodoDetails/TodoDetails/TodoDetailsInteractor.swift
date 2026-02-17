//
//  TodoDetailsInteractorInteractor.swift
//  Todo
//
//  
//  TodoDetailsInteractor.swift
//  Todo
//
//  Created by Aleksandr Lis on 18.02.2026.
//
//

import Foundation

protocol ITodoDetailsInteractorInput: AnyObject {}

protocol ITodoDetailsInteractorOutput: AnyObject {}

final class TodoDetailsInteractor {

    weak var output: ITodoDetailsInteractorOutput?
}

// MARK: - TodoDetailsInteractor

extension TodoDetailsInteractor: ITodoDetailsInteractorInput {

}
