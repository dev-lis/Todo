//
//  TodoListService.swift
//  Todo
//
//  Created by Aleksandr Lis on 15.02.2026.
//

import Network
import Storage

// sourcery: AutoMockable
protocol ITodoListService {
    func fetchTodoList(completion: @escaping (Result<TodoList, Error>) -> Void)
    func updateTodo(_ todo: Todo)
}

final class TodoListService: ITodoListService {

    private let networkService: INetworkService
    private let requestBuilder: ITodoRequestBuilder
    private let coreDataRepository: ICoreDataRepository
    private let todoListToEntityMapper: ITodoListToEntityMapper
    private let todoListEntityToDTOMapper: TodoListEntityToDTOMapper

    init(networkService: INetworkService,
         requestBuilder: ITodoRequestBuilder,
         coreDataRepository: ICoreDataRepository,
         todoListToEntityMapper: ITodoListToEntityMapper,
         todoListEntityToDTOMapper: TodoListEntityToDTOMapper) {
        self.networkService = networkService
        self.requestBuilder = requestBuilder
        self.coreDataRepository = coreDataRepository
        self.todoListToEntityMapper = todoListToEntityMapper
        self.todoListEntityToDTOMapper = todoListEntityToDTOMapper
    }

    func fetchTodoList(completion: @escaping (Result<TodoList, Error>) -> Void) {
        do {
            let todoListEntity = try coreDataRepository.fetchFirst(TodoListEntity.self)
            let todoList = todoListEntity.map { todoListEntityToDTOMapper.map(entity: $0) }
            if let todoList, !todoList.todos.isEmpty {
                completion(.success(todoList))
                return
            }
            /*
             Запрашиваем данные из сети только первый раз
             для того чтобы все дальнейшие обновления были через БД
            */

            let request = try requestBuilder.todoListdRequest()
            networkService.request(request) { [weak self] result in
                completion(result)
                guard case .success(let todoList) = result else {
                    return
                }
                self?.saveOrUpdateInCoreData(todoList)
            }
        } catch {
            completion(.failure(error))
        }
    }

    func updateTodo(_ todo: Todo) {
        do {
            try coreDataRepository.upsert(
                TodoEntity.self,
                idKey: "id",
                idValue: todo.id as NSString) { object in
                    object.date = todo.date
                    object.title = todo.title
                    object.taskDescription = todo.description
                    object.isCompleted = todo.isCompleted
                }
        } catch {
            print("Update did finished with error: \(error)")
        }
    }

    private func saveOrUpdateInCoreData(_ todoList: TodoList) {
        coreDataRepository.performBackgroundTask { [weak self] context in
            do {
                try self?.todoListToEntityMapper.map(dto: todoList, context: context)
                try self?.coreDataRepository.save(context: context)
            } catch {
                print(error)
            }
        }
    }
}
