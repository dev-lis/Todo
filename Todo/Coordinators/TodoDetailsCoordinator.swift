//
//  TodoDetailsCoordinator.swift
//  Todo
//
//  Created by Aleksandr Lis on 18.02.2026.
//

import UIKit

final class TodoDetailsCoordinator: BaseCoordinator {

    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    override func start() {
        let viewController = TodoDetailsAssembly.asseble()
        navigationController?.pushViewController(viewController, animated: true)
    }
}
