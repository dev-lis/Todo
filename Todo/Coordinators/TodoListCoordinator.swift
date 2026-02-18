//
//  TodoListCoordinator.swift
//  Todo
//
//  Created by Aleksandr Lis on 15.02.2026.
//

import UIKit

final class TodoListCoordinator: BaseCoordinator {

    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    override func start() {
        let viewController = TodoListAssembly.asseble(moduleOutput: self)
        navigationController?.setViewControllers([viewController], animated: false)
    }
}

// MARK: - TodoListModuleOutput

extension TodoListCoordinator: TodoListModuleOutput {
    func openNewTodoDetail() {
        openTodoDetail(for: nil)
    }

    func openTodoDetail(for id: Int?) {
        let todoDetailsCoordinator = TodoDetailsCoordinator(
            todoId: id,
            navigationController: navigationController
        )
        todoDetailsCoordinator.start()

        addChild(todoDetailsCoordinator)
    }
}
