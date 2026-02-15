//  
//  TodoListAssembly.swift
//  Todo
//
//  Created by Aleksandr on 15.02.2026.
//
//

import Network
import UIKit

final class TodoListAssembly {

    static func asseble() -> UIViewController {
        let router = TodoListRouter()
        let todoListService = TodoListService()
        let interactor = TodoListInteractor(
            todoListService: todoListService
        )
        let dateFormatter = TodoDateFormatter()
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
        router.viewController = view

        return view
    }
}
