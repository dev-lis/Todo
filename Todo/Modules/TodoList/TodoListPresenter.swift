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

    weak var view: ITodoListView?

    private var interactor: ITodoListInteractorInput?
    private var router: ITodoListRouter?

    init(interactor: ITodoListInteractorInput,
         router: ITodoListRouter) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - ITodoListPresenter

extension TodoListPresenter: ITodoListPresenter {
    func viewDidLoad() {}
}

// MARK: - ITodoListInteractorOutput

extension TodoListPresenter: ITodoListInteractorOutput {}
