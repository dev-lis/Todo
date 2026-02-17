//
//  DTOToEntityMapping.swift
//  Todo
//

import CoreData
import Storage

// MARK: - DTO → Entity

protocol EntityMappable {
    associatedtype Entity: NSManagedObject
    func map(to entity: Entity)
}

// MARK: - DTO → Entity

protocol IDTOToEntityMapper {
    associatedtype DTO
    associatedtype Entity: NSManagedObject
    @discardableResult
    func map(dto: DTO, context: NSManagedObjectContext) throws -> Entity
}

// MARK: - TodoToEntityMapper

final class TodoToEntityMapper {
    func map(dto: Todo, to entity: TodoEntity) {
        entity.id = Int64(dto.id)
        entity.title = dto.title
        entity.taskDescription = dto.description
        entity.date = dto.date
        entity.isCompleted = dto.isCompleted
    }
}

// MARK: - ITodoListToEntityMapper

protocol ITodoListToEntityMapper {
    @discardableResult
    func map(dto: TodoList, context: NSManagedObjectContext) throws -> TodoListEntity
}

// MARK: - TodoListToEntityMapper

final class TodoListToEntityMapper: ITodoListToEntityMapper, IDTOToEntityMapper {
    typealias DTO = TodoList
    typealias Entity = TodoListEntity

    private let repository: ICoreDataRepository
    private let todoMapper: TodoToEntityMapper

    init(repository: ICoreDataRepository, todoMapper: TodoToEntityMapper = TodoToEntityMapper()) {
        self.repository = repository
        self.todoMapper = todoMapper
    }

    @discardableResult
    func map(dto: TodoList, context: NSManagedObjectContext) throws -> TodoListEntity {
        let rootEntity: TodoListEntity = try getOrCreateRoot(in: context)
        mapRoot(dto: dto, to: rootEntity)
        try mapChildren(dtos: dto.todos, parent: rootEntity, context: context)
        return rootEntity
    }

    private func getOrCreateRoot(in context: NSManagedObjectContext) throws -> TodoListEntity {
        if let existing = try repository.fetchFirst(
            TodoListEntity.self,
            predicate: nil,
            sortDescriptors: [],
            in: context
        ) {
            return existing
        }
        return try repository.create(TodoListEntity.self, in: context) { _ in }
    }

    private func mapRoot(dto: TodoList, to entity: TodoListEntity) {
        entity.total = Int64(dto.total)
        entity.limit = Int64(dto.limit)
    }

    private func mapChildren(dtos: [Todo], parent: TodoListEntity, context: NSManagedObjectContext) throws {
        for todo in dtos {
            _ = try repository.upsert(
                TodoEntity.self,
                idKey: "id",
                idValue: todo.id,
                in: context
            ) { [todoMapper] entity in
                todoMapper.map(dto: todo, to: entity)
                entity.todoList = parent
            }
        }
    }
}
