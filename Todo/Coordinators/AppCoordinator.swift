//
//  AppCoordinator.swift
//  Todo
//
//  Created by Aleksandr Lis on 14.02.2026.
//

import Storage
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

        self.setupCoreData()
    }
}

private extension AppCoordinator {
    func setupCoreData() {
        let stack = ServiceLocator.shared.resolveOrFail(ICoreDataStack.self)
        stack.load { error in
            if let error = error as NSError? {
                print("Core Data load error: \(error.localizedDescription)")
            }
        }
    }
}
