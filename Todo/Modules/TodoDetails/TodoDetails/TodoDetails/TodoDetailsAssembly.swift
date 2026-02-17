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

    static func asseble() -> UIViewController {
        let router = TodoDetailsRouter()
        let interactor = TodoDetailsInteractor()
        let presenter = TodoDetailsPresenter(
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
