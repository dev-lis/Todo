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
    func viewDidLoad() {
        view?.display(
            title: "Заняться спортом",
            date: "02/10/24",
            description: "Составить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике."
        )
    }
}

// MARK: - ITodoDetailsInteractorOutput

extension TodoDetailsPresenter: ITodoDetailsInteractorOutput {}
