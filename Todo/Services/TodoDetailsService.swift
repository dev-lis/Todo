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

    private let queue = DispatchQueue(label: "com.aleksandrlis.todo.TodoDetailsService")

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
        queue.async {
            do {
                let entity = try self.coreDataRepository.fetchFirst(
                    TodoEntity.self,
                    predicate: NSPredicate(format: "id == %@", id as NSString),
                    sortDescriptors: [],
                    in: nil
                )
                guard let entity else {
                    completion(.failure(TodoDetailsError.todoNotFound(id: id)))
                    return
                }
                let doto = self.todoEntityToDTOMapper.map(entity: entity)
                completion(.success(doto))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func saveTodo(_ todo: Todo, completion: @escaping (Result<Void, Error>) -> Void) {
        queue.async {
            do {
                let rootList: TodoListEntity
                if let list = try self.coreDataRepository.fetchFirst(TodoListEntity.self, in: nil) {
                    rootList = list
                } else {
                    rootList = try self.coreDataRepository.create(TodoListEntity.self, in: nil) { _ in }
                }
                try self.coreDataRepository.upsert(
                    TodoEntity.self,
                    idKey: "id",
                    idValue: todo.id as NSString,
                    in: nil
                ) { entity in
                    self.todoToEntityMapper.map(dto: todo, to: entity)
                    entity.todoList = rootList
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
