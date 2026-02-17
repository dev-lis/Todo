//
//  TodoDetailsPresenterPresenter.swift
//  Todo
//
//  
//  TodoDetailsPresenter.swift
//  Todo
//
//  Created by Aleksandr Lis on 18.02.2026.
//
//

import Foundation

protocol ITodoDetailsPresenter {
    func viewDidLoad()
}

final class TodoDetailsPresenter {

    weak var view: ITodoDetailsView?

    private let interactor: ITodoDetailsInteractorInput
    private let router: ITodoDetailsRouter

    init(interactor: ITodoDetailsInteractorInput,
         router: ITodoDetailsRouter) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - ITodoDetailsPresenter

extension TodoDetailsPresenter: ITodoDetailsPresenter {
    func viewDidLoad() {}
}

// MARK: - ITodoDetailsInteractorOutput

extension TodoDetailsPresenter: ITodoDetailsInteractorOutput {}
