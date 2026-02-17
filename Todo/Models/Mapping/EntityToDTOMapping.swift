//
//  EntityToDTOMapping.swift
//  Todo
//

import CoreData

// MARK: - EntityMappableToDTO

/// Протокол для маппинга NSManagedObject в DTO (обратное преобразование).
protocol EntityMappableToDTO {
    associatedtype DTO
    func toDTO() -> DTO
}

// MARK: - mapFromEntity (root + вложенный массив)

/// Собирает корневой DTO из корневой сущности и вложенного массива дочерних сущностей.
/// Универсальный инструмент: извлечь детей из родителя → маппить каждого в ChildDTO → собрать RootDTO.
func mapFromEntity<RootEntity, RootDTO, ChildEntity, ChildDTO>(
    rootEntity: RootEntity,
    childEntitiesFromRoot: (RootEntity) -> [ChildEntity],
    buildRootDTO: (RootEntity, [ChildDTO]) -> RootDTO,
    mapChild: (ChildEntity) -> ChildDTO
) -> RootDTO {
    let childEntities = childEntitiesFromRoot(rootEntity)
    let childDTOs = childEntities.map(mapChild)
    return buildRootDTO(rootEntity, childDTOs)
}
