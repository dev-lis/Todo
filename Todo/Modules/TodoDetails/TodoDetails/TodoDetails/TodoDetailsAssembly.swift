//  
//  TodoDetailsAssembly.swift
//  Todo
//
//  Created by Aleksandr Lis on 18.02.2026.
//
//

import AppUIKit
import UIKit

final class TodoDetailsAssembly {

    static func asseble(todoId: String?, moduleOutput: TodoDetailsModuleOutput) -> UIViewController {
        let locator = ServiceLocator.shared

        let todoDetailsService = locator.resolveOrFail(ITodoDetailsService.self)
        let interactor = TodoDetailsInteractor(
            todoDetailsService: todoDetailsService
        )
        let router = TodoDetailsRouter()
        let dateFormatter = locator.resolveOrFail(IDateFormatter.self)
        let presenter = TodoDetailsPresenter(
            todoId: todoId,
            interactor: interactor,
            router: router,
            dateFormatter: dateFormatter
        )
        let view = TodoDetailsViewController(
            presenter: presenter
        )

        interactor.output = presenter
        presenter.view = view
        presenter.moduleOutput = moduleOutput
        router.viewController = view

        return view
    }
}
