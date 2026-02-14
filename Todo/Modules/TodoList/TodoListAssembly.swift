//
//  TodoListAssemblyWireframe.swift
//  Todo
//
//  
//  TodoListAssembly.swift
//  Todo
//
//  Created by Aleksandr on 15.02.2026.
//
//

import UIKit

final class TodoListAssembly {

    static func asseble() -> UIViewController {
        let router = TodoListRouter()
        let interactor = TodoListInteractor()
        let presenter = TodoListPresenter(
            interactor: interactor,
            router: router
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
