//  
//  TodoListRouter.swift
//  Todo
//
//  Created by Aleksandr Lis on 15.02.2026.
//
//

import UIKit

// sourcery: AutoMockable
protocol ITodoListRouter {}

final class TodoListRouter {

    weak var viewController: UIViewController?
}

// MARK: - ITodoListRouter

extension TodoListRouter: ITodoListRouter {}
