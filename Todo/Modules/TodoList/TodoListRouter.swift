//
//  TodoListRouterRouter.swift
//  Todo
//
//  
//  TodoListRouter.swift
//  Todo
//
//  Created by Aleksandr on 15.02.2026.
//
//

import UIKit

protocol ITodoListRouter {}

final class TodoListRouter {

    weak var viewController: UIViewController?
}

// MARK: - ITodoListRouter

extension TodoListRouter: ITodoListRouter {}
