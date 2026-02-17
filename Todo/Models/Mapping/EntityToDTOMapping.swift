//
//  EntityToDTOMapping.swift
//  Todo
//

import CoreData

// MARK: - Entity → DTO

protocol IEntityToDTOMapper {
    associatedtype Entity: NSManagedObject
    associatedtype DTO
    func map(entity: Entity) -> DTO
}

// MARK: - TodoEntityToDTOMapper

final class TodoEntityToDTOMapper: IEntityToDTOMapper {
    typealias Entity = TodoEntity
    typealias DTO = Todo

    func map(entity: TodoEntity) -> Todo {
        Todo(
            id: Int(entity.id),
            title: entity.title ?? "",
            description: entity.taskDescription ?? "",
            date: entity.date ?? Date(),
            isCompleted: entity.isCompleted
        )
    }
}

// MARK: - TodoListEntityToDTOMapper

final class TodoListEntityToDTOMapper: IEntityToDTOMapper {
    typealias Entity = TodoListEntity
    typealias DTO = TodoList

    private let todoMapper: TodoEntityToDTOMapper

    init(todoMapper: TodoEntityToDTOMapper = TodoEntityToDTOMapper()) {
        self.todoMapper = todoMapper
    }

    func map(entity: TodoListEntity) -> TodoList {
        let childEntities = (entity.todos?.allObjects as? [TodoEntity]) ?? []
        let todoDTOs = childEntities.map { todoMapper.map(entity: $0) }
        return TodoList(
            todos: todoDTOs,
            total: Int(entity.total),
            limit: Int(entity.limit)
        )
    }
}
