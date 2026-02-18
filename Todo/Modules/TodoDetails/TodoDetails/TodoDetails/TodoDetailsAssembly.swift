//
//  TodoDetailsAssemblyWireframe.swift
//  Todo
//
//  
//  TodoDetailsAssembly.swift
//  Todo
//
//  Created by Aleksandr Lis on 18.02.2026.
//
//

import UIKit

final class TodoDetailsAssembly {

    static func asseble(todoId: Int) -> UIViewController {
        let router = TodoDetailsRouter()
        let interactor = TodoDetailsInteractor()
        let presenter = TodoDetailsPresenter(
            todoId: todoId
            interactor: interactor,
            router: router
        )
        let view = TodoDetailsViewController(
            presenter: presenter
        )

        interactor.output = presenter
        presenter.view = view
        router.viewController = view

        return view
    }
}
