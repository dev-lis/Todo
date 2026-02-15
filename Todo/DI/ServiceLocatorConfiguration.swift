//
//  ServiceLocatorConfiguration.swift
//  Todo
//
//  Created by Aleksandr Lis on 15.02.2026.
//

import Network

enum ServiceLocatorConfiguration {
    static func configure() {
        let locator = ServiceLocator.shared

        // INetworkService
        locator.registerSingleton(INetworkService.self) {
            let configuration = URLSessionConfiguration.default
            configuration.protocolClasses?.insert(MockURLProtocol.self, at: 0)
            MockURLProtocol.mockedURL = URL(string: "https://dummyjson.com/todos")
            MockURLProtocol.mockedData = JSONParser.data(from: "todo_list")
            let session = URLSession(configuration: configuration)
            return NetworkService(session: session) as INetworkService
        }

        // ITodoRequestBuilder
        locator.register(ITodoRequestBuilder.self) {
            TodoRequestBuilder() as ITodoRequestBuilder
        }

        // ITodoListService
        locator.registerSingleton(ITodoListService.self) {
            let networkService = locator.resolveOrFail(INetworkService.self)
            let requestBuilder = locator.resolveOrFail(ITodoRequestBuilder.self)
            return TodoListService(networkService: networkService, requestBuilder: requestBuilder) as ITodoListService
        }

        // IDateFormatter
        locator.registerSingleton(IDateFormatter.self) {
            TodoDateFormatter() as IDateFormatter
        }
    }
}
