//
//  ServiceLocator.swift
//  Todo
//
//  Created by Aleksandr Lis on 15.02.2026.
//

import Foundation

final class ServiceLocator {

    static let shared = ServiceLocator()

    private var services: [String: Any] = [:]
    private var factories: [String: () -> Any] = [:]
    private let lock = NSLock()

    private init() {}
}

extension ServiceLocator {
    func registerSingleton<T>(_ type: T.Type, factory: @escaping () -> T) {
        lock.lock()
        defer { lock.unlock() }
        let key = String(describing: type)
        factories[key] = { [weak self] in
            guard let self else { return factory() }
            self.lock.lock()
            if let existing = self.services[key] as? T {
                self.lock.unlock()
                return existing
            }
            self.lock.unlock()
            let instance = factory()
            self.lock.lock()
            self.services[key] = instance
            self.factories.removeValue(forKey: key)
            self.lock.unlock()
            return instance
        }
    }

    func register<T>(_ type: T.Type, factory: @escaping () -> T) {
        lock.lock()
        defer { lock.unlock() }
        let key = String(describing: type)
        factories[key] = { factory() }
        services.removeValue(forKey: key)
    }
}

extension ServiceLocator {
    func resolve<T>(_ type: T.Type) -> T? {
        lock.lock()
        let key = String(describing: type)

        if let service = services[key] as? T {
            lock.unlock()
            return service
        }

        if let factory = factories[key] {
            lock.unlock()
            let instance = factory()
            lock.lock()
            if let typed = instance as? T {
                lock.unlock()
                return typed
            }
            lock.unlock()
            return instance as? T
        }

        lock.unlock()
        return nil
    }

    func resolveOrFail<T>(_ type: T.Type) -> T {
        guard let service = resolve(type) else {
            fatalError("ServiceLocator: не найден сервис \(type)")
        }
        return service
    }
}
