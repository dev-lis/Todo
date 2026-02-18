//  
//  TodoDetailsRouter.swift
//  Todo
//
//  Created by Aleksandr Lis on 18.02.2026.
//
//

import UIKit

// sourcery: AutoMockable
protocol ITodoDetailsRouter: AlertRouterTrait {
    func showAlert(message: String)
}

extension ITodoDetailsRouter {
    func showAlert(message: String) {
        showAlert(title: nil, message: message, onOk: nil)
    }
}

final class TodoDetailsRouter {

    weak var viewController: UIViewController?
}

// MARK: - ITodoDetailsRouter

extension TodoDetailsRouter: ITodoDetailsRouter {}
