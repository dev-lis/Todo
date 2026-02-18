//
//  TodoDetailsService.swift
//  Todo
//
//  Created by Aleksandr Lis on 18.02.2026.
//

import Foundation
import Storage

protocol ITodoDetailsService {
    func fetchTodo(by id: Int, completion: @escaping (Result<Todo, Error>) -> Void)
}

final class TodoDetailsService: ITodoDetailsService {

    private let coreDataRepository: ICoreDataRepository
    private let todoListToEntityMapper: ITodoListToEntityMapper
    private let todoListEntityToDTOMapper: TodoListEntityToDTOMapper
    private let todoEntityToDTOMapper: TodoEntityToDTOMapper

    init(coreDataRepository: ICoreDataRepository,
         todoListToEntityMapper: ITodoListToEntityMapper,
         todoListEntityToDTOMapper: TodoListEntityToDTOMapper,
         todoEntityToDTOMapper: TodoEntityToDTOMapper = TodoEntityToDTOMapper()) {
        self.coreDataRepository = coreDataRepository
        self.todoListToEntityMapper = todoListToEntityMapper
        self.todoListEntityToDTOMapper = todoListEntityToDTOMapper
        self.todoEntityToDTOMapper = todoEntityToDTOMapper
    }

    func fetchTodo(by id: Int, completion: @escaping (Result<Todo, Error>) -> Void) {
        do {
            let entity = try coreDataRepository.fetchFirst(
                TodoEntity.self,
                predicate: NSPredicate(format: "id == %@", NSNumber(value: id)),
                sortDescriptors: [],
                in: nil
            )
            guard let entity else {
                completion(.failure(TodoDetailsError.todoNotFound(id: id)))
                return
            }
            let doto = todoEntityToDTOMapper.map(entity: entity)
            completion(.success(doto))
        } catch {
            completion(.failure(error))
        }
    }
}

enum TodoDetailsError: Error {
    case todoNotFound(id: Int)
}
