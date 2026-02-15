//
//  TodoListService.swift
//  Todo
//
//  Created by Aleksandr Lis on 15.02.2026.
//

import Network

protocol ITodoListService {
    func fetchTodoList(completion: @escaping (Result<TodoList, Error>) -> Void)
}

final class TodoListService: ITodoListService {

    private let networkService: INetworkService
    private let requestBuilder: ITodoRequestBuilder

    init(networkService: INetworkService,
         requestBuilder: ITodoRequestBuilder) {
        self.networkService = networkService
        self.requestBuilder = requestBuilder
    }

    func fetchTodoList(completion: @escaping (Result<TodoList, Error>) -> Void) {
        do {
            let request = try requestBuilder.todoListdRequest()
            networkService.request(request, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }
}
