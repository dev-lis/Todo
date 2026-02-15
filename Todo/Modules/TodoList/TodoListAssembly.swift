//  
//  TodoListAssembly.swift
//  Todo
//
//  Created by Aleksandr Lis on 15.02.2026.
//
//

import Network
import UIKit

final class TodoListAssembly {

    static func asseble() -> UIViewController {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses?.insert(MockURLProtocol.self, at: 0)
        MockURLProtocol.mockedURL = URL(string: "https://dummyjson.com/todos")
        MockURLProtocol.mockedData = JSONParser.data(from: "todo_list")
        let session = URLSession(configuration: configuration)
        let networkService = NetworkService(session: session)

        
        let todoListService = TodoListService(
            networkService: networkService,
            requestBuilder: TodoRequestBuilder()
        )
        let interactor = TodoListInteractor(
            todoListService: todoListService
        )
        let router = TodoListRouter()
        let dateFormatter = TodoDateFormatter()
        let presenter = TodoListPresenter(
            interactor: interactor,
            router: router,
            dateFormatter: dateFormatter
        )
        let view = TodoListViewController(
            presenter: presenter
        )

        interactor.output = presenter
        presenter.view = view
        router.viewController = view

        return view
    }
}
