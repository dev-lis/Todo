//
//  ServiceLocatorConfiguration.swift
//  Todo
//
//  Created by Aleksandr Lis on 15.02.2026.
//

import AppUIKit
import Network
import Storage

enum ServiceLocatorConfiguration {
    static func configure() {
        let locator = ServiceLocator.shared

        // INetworkService
        locator.registerSingleton(INetworkService.self) {
            let session: URLSession
            if BuildConfiguration.isDev {
                /*
                 Поскольку с dummyjson не очень подходил под UI макетов,
                 была добавлена возможность перехватить запрос в сеть и заменить его на локальный мок,
                 который находится /Resources/todo_list.json
                 */
                let configuration = URLSessionConfiguration.default
                configuration.protocolClasses?.insert(MockURLProtocol.self, at: 0)
                MockURLProtocol.mockedURL = URL(string: "https://dummyjson.com/todos")
                MockURLProtocol.mockedData = JSONParser.data(from: "todo_list")
                session = URLSession(configuration: configuration)
            } else {
                session = .shared
            }
            return NetworkService(session: session) as INetworkService
        }

        // ITodoRequestBuilder
        locator.register(ITodoRequestBuilder.self) {
            TodoRequestBuilder() as ITodoRequestBuilder
        }

        // CoreDataStack
        locator.registerSingleton(ICoreDataStack.self) {
            let stack = CoreDataStack(modelName: "Storage", bundle: .main)
            return stack
        }

        // ICoreDataRepository
        locator.registerSingleton(ICoreDataRepository.self) {
            let stack = locator.resolveOrFail(ICoreDataStack.self)
            let repository = CoreDataRepository(stack: stack)
            return repository
        }

        // ITodoListService
        locator.registerSingleton(ITodoListService.self) {
            let networkService = locator.resolveOrFail(INetworkService.self)
            let requestBuilder = locator.resolveOrFail(ITodoRequestBuilder.self)
            let coreDataRepository = locator.resolveOrFail(ICoreDataRepository.self)
            return TodoListService(
                networkService: networkService,
                requestBuilder: requestBuilder,
                coreDataRepository: coreDataRepository
            ) as ITodoListService
        }

        // IDateFormatter
        locator.registerSingleton(IDateFormatter.self) {
            TodoDateFormatter() as IDateFormatter
        }
    }
}
