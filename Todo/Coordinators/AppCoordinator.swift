//
//  AppCoordinator.swift
//  Todo
//
//  Created by Aleksandr Lis on 14.02.2026.
//

import UIKit

final class AppCoordinator: BaseCoordinator {

    private weak var rootController: UINavigationController?
    private weak var window: UIWindow?

    init(window: UIWindow?) {
        self.window = window
    }

    override func start() {
        let navigationController = UINavigationController()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        rootController = navigationController

        let todoListCoordinator = TodoListCoordinator(navigationController: navigationController)
        todoListCoordinator.start()
    }
}
