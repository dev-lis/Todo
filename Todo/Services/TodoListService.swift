//
//  TodoListService.swift
//  Todo
//
//  Created by Aleksandr Lis on 15.02.2026.
//

import Network
import Storage

protocol ITodoListService {
    func fetchTodoList(completion: @escaping (Result<TodoList, Error>) -> Void)
}

final class TodoListService: ITodoListService {

    private let networkService: INetworkService
    private let requestBuilder: ITodoRequestBuilder
    private let coreDataRepository: ICoreDataRepository

    init(networkService: INetworkService,
         requestBuilder: ITodoRequestBuilder,
         coreDataRepository: ICoreDataRepository) {
        self.networkService = networkService
        self.requestBuilder = requestBuilder
        self.coreDataRepository = coreDataRepository
    }

    func fetchTodoList(completion: @escaping (Result<TodoList, Error>) -> Void) {
        do {
            let request = try requestBuilder.todoListdRequest()
            networkService.request(request) { [weak self] result in
                
            }
        } catch {
            completion(.failure(error))
        }
    }
}
