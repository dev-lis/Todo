//
//  DTOToEntityMapping.swift
//  Todo
//

import CoreData
import Storage

// MARK: - EntityMappable

/// Протокол для маппинга DTO в существующий NSManagedObject (заполнение полей).
protocol EntityMappable {
    associatedtype Entity: NSManagedObject
    func map(to entity: Entity)
}

// MARK: - NestedMapping

/// Описание маппинга вложенного массива: список дочерних DTO → сущности с привязкой к родителю.
struct NestedMapping<ParentEntity: NSManagedObject, ChildDTO, ChildEntity: NSManagedObject> {
    let idKey: String
    let idFromDTO: (ChildDTO) -> CVarArg
    let mapDTOToEntity: (ChildDTO, ChildEntity) -> Void
    let setParent: (ChildEntity, ParentEntity) -> Void
}

// MARK: - mapToEntity (root + one nested array)

/// Маппит корневой DTO в корневую сущность и один вложенный массив в дочерние сущности.
/// - Parameters:
///   - existingRoot: если передан — используется как корень (только rootMap + дети); иначе корень создаётся/upsert'ится.
///   - rootUpsertIdKey / rootUpsertIdValue: если оба заданы — корень upsert по id; иначе create.
func mapToEntity<RootDTO, RootEntity: NSManagedObject, ChildDTO, ChildEntity: NSManagedObject>(
    rootDTO: RootDTO,
    existingRoot: RootEntity?,
    rootUpsertIdKey: String?,
    rootUpsertIdValue: CVarArg?,
    rootMap: (RootDTO, RootEntity) -> Void,
    childDTOs: [ChildDTO],
    childMapping: NestedMapping<RootEntity, ChildDTO, ChildEntity>,
    repository: ICoreDataRepository,
    context: NSManagedObjectContext
) throws -> RootEntity {
    let rootEntity: RootEntity
    if let existing = existingRoot {
        rootEntity = existing
        rootMap(rootDTO, rootEntity)
    } else if let idKey = rootUpsertIdKey, let idValue = rootUpsertIdValue {
        rootEntity = try repository.upsert(RootEntity.self, idKey: idKey, idValue: idValue, in: context) { entity in
            rootMap(rootDTO, entity)
        }
    } else {
        rootEntity = try repository.create(RootEntity.self, in: context) { entity in
            rootMap(rootDTO, entity)
        }
    }

    for dto in childDTOs {
        let idValue = childMapping.idFromDTO(dto)
        _ = try repository.upsert(
            ChildEntity.self,
            idKey: childMapping.idKey,
            idValue: idValue,
            in: context
        ) { entity in
            childMapping.mapDTOToEntity(dto, entity)
            childMapping.setParent(entity, rootEntity)
        }
    }

    return rootEntity
}
