//  
//  TodoListAssembly.swift
//  Todo
//
//  Created by Aleksandr Lis on 15.02.2026.
//
//

import AppUIKit

final class TodoListAssembly {

    static func asseble(moduleOutput: TodoListModuleOutput) -> UIViewController {
        let locator = ServiceLocator.shared

        let todoListService = locator.resolveOrFail(ITodoListService.self)
        let interactor = TodoListInteractor(todoListService: todoListService)
        let router = TodoListRouter()
        let dateFormatter = locator.resolveOrFail(IDateFormatter.self)
        let presenter = TodoListPresenter(
            interactor: interactor,
            router: router,
            dateFormatter: dateFormatter
        )
        let view = TodoListViewController(
            presenter: presenter
        )

        interactor.output = presenter
        presenter.view = view
        presenter.moduleOutput = moduleOutput
        router.viewController = view

        return view
    }
}
