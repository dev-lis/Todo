//
//  AppCoordinator.swift
//  Todo
//
//  Created by Aleksandr Lis on 14.02.2026.
//

import UIKit

protocol Coordinator {
    func start()
}

final class AppCoordinator: Coordinator {

    private weak var rootController: UINavigationController?

    private weak var window: UIWindow?

    init(window: UIWindow?) {
        self.window = window
    }

    func start() {
        let viewController = TodoListAssembly.asseble()
        let navigationController = UINavigationController(rootViewController: viewController)

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        self.rootController = navigationController
    }
}
