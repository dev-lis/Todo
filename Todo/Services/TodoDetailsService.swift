//
//  TodoDetailsService.swift
//  Todo
//
//  Created by Aleksandr Lis on 18.02.2026.
//

import Foundation
import Storage

protocol ITodoDetailsService {
    func fetchTodo(by id: String, completion: @escaping (Result<Todo, Error>) -> Void)
    func saveTodo(_ todo: Todo, completion: @escaping (Result<Void, Error>) -> Void)
}

final class TodoDetailsService: ITodoDetailsService {

    private let coreDataRepository: ICoreDataRepository
    private let todoListToEntityMapper: ITodoListToEntityMapper
    private let todoListEntityToDTOMapper: TodoListEntityToDTOMapper
    private let todoEntityToDTOMapper: TodoEntityToDTOMapper

    private let todoToEntityMapper: TodoToEntityMapper

    init(coreDataRepository: ICoreDataRepository,
         todoListToEntityMapper: ITodoListToEntityMapper,
         todoListEntityToDTOMapper: TodoListEntityToDTOMapper,
         todoEntityToDTOMapper: TodoEntityToDTOMapper = TodoEntityToDTOMapper(),
         todoToEntityMapper: TodoToEntityMapper = TodoToEntityMapper()) {
        self.coreDataRepository = coreDataRepository
        self.todoListToEntityMapper = todoListToEntityMapper
        self.todoListEntityToDTOMapper = todoListEntityToDTOMapper
        self.todoEntityToDTOMapper = todoEntityToDTOMapper
        self.todoToEntityMapper = todoToEntityMapper
    }

    func fetchTodo(by id: String, completion: @escaping (Result<Todo, Error>) -> Void) {
        do {
            let entity = try coreDataRepository.fetchFirst(
                TodoEntity.self,
                predicate: NSPredicate(format: "id == %@", id as NSString),
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

    func saveTodo(_ todo: Todo, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }
            do {
                try self.coreDataRepository.upsert(
                    TodoEntity.self,
                    idKey: "id",
                    idValue: todo.id as NSString,
                    in: nil
                ) { entity in
                    self.todoToEntityMapper.map(dto: todo, to: entity)
                }
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

enum TodoDetailsError: Error {
    case todoNotFound(id: String)
}
