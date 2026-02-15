//
//  BaseCoordinator.swift
//  Todo
//
//  Created by Aleksandr Lis on 15.02.2026.
//

import UIKit

protocol Coordinator: AnyObject {
    func start()
}

class BaseCoordinator: Coordinator {

    private(set) var childCoordinators: [Coordinator] = []
    private let lock = NSLock()
    weak var parent: BaseCoordinator?

    func start() {
        fatalError("Override start()")
    }
}

// MARK: - Child Coordinators

extension BaseCoordinator {
    func addChild(_ coordinator: Coordinator) {
        lock.lock()
        defer { lock.unlock() }
        (coordinator as? BaseCoordinator)?.parent = self
        childCoordinators.append(coordinator)
    }

    func removeChild(_ coordinator: Coordinator) {
        lock.lock()
        defer { lock.unlock() }
        (coordinator as? BaseCoordinator)?.parent = nil
        childCoordinators.removeAll { $0 === coordinator }
    }

    func finishChild(_ coordinator: Coordinator) {
        removeChild(coordinator)
    }

    func finish() {
        parent?.finishChild(self)
    }
}
