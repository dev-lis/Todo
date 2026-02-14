//
//  ___FILEBASENAME___Wireframe.swift
//  ___PACKAGENAME___
//
//  ___FILEHEADER___
//

import UIKit

final class ___VARIABLE_productName:identifier___Assembly {

    static func asseble() -> UIViewController {
        let router = ___VARIABLE_productName:identifier___Router()
        let interactor = ___VARIABLE_productName:identifier___Interactor()
        let presenter = ___VARIABLE_productName:identifier___Presenter(
            interactor: interactor,
            router: router
        )
        let view = ___VARIABLE_productName:identifier___ViewController(
            presenter: presenter
        )

        interactor.output = presenter
        presenter.view = view
        router.viewController = view

        return view
    }
}
