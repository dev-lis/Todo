//
//  TodoDetailsCoordinator.swift
//  Todo
//
//  Created by Aleksandr Lis on 18.02.2026.
//

import UIKit

final class TodoDetailsCoordinator: BaseCoordinator {

    private let todoId: Int
    private weak var navigationController: UINavigationController?

    init(todoId: Int,
         navigationController: UINavigationController?) {
        self.todoId = todoId
        self.navigationController = navigationController
    }

    override func start() {
        let viewController = TodoDetailsAssembly.asseble(
            todoId: todoId,
            moduleOutput: self
        )
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - TodoDetailsModuleOutput

extension TodoDetailsCoordinator: TodoDetailsModuleOutput {
    func todoDetailsDidFinish() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
            self.finish()
        }
    }
}
