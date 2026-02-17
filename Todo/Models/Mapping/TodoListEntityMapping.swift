//
//  TodoListEntityMapping.swift
//  Todo
//

import CoreData
import Storage

// MARK: - TodoEntity → Todo (обратный маппинг)

extension TodoEntity: EntityMappableToDTO {
    typealias DTO = Todo

    func toDTO() -> Todo {
        Todo(
            id: Int(id),
            title: title ?? "",
            description: taskDescription ?? "",
            date: date ?? Date(),
            isCompleted: isCompleted
        )
    }
}

// MARK: - TodoListEntity → TodoList (обратный маппинг с вложенным массивом)

extension TodoListEntity {
    /// Собирает TodoList из сущности и вложенных TodoEntity.
    func toDTO() -> TodoList {
        mapFromEntity(
            rootEntity: self,
            childEntitiesFromRoot: { root in
                (root.todos?.allObjects as? [TodoEntity]) ?? []
            },
            buildRootDTO: { entity, todoDTOs in
                TodoList(
                    todos: todoDTOs,
                    total: Int(entity.total),
                    limit: Int(entity.limit)
                )
            },
            mapChild: { $0.toDTO() }
        )
    }
}

// MARK: - Todo → TodoEntity

extension Todo: EntityMappable {
    typealias Entity = TodoEntity

    func map(to entity: TodoEntity) {
        entity.id = Int64(id)
        entity.title = title
        entity.taskDescription = description
        entity.date = date
        entity.isCompleted = isCompleted
    }
}

// MARK: - TodoList → TodoListEntity (корень)

extension TodoList {
    func mapToRootEntity(_ entity: TodoListEntity) {
        entity.total = Int64(total)
        entity.limit = Int64(limit)
    }
}

// MARK: - NestedMapping для todos

extension TodoList {
    /// Дескриптор маппинга вложенного массива `todos` в `TodoEntity` с родителем `TodoListEntity`.
    static func todosNestedMapping() -> NestedMapping<TodoListEntity, Todo, TodoEntity> {
        NestedMapping(
            idKey: "id",
            idFromDTO: { todo in todo.id as CVarArg },
            mapDTOToEntity: { todo, entity in todo.map(to: entity) },
            setParent: { entity, parent in entity.todoList = parent }
        )
    }
}
