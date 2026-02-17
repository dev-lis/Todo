//
//  CoreDataRepository.swift
//  Storage
//
//  Created by Aleksandr Lis on 16.02.2026.
//

import CoreData

/// Универсальный репозиторий для работы с Core Data. Поддерживает любые NSManagedObject-модели.
public final class CoreDataRepository {

    private let stack: CoreDataStack

    public init(stack: CoreDataStack) {
        self.stack = stack
    }

    // MARK: - Create

    /// Создаёт объект указанного типа.
    @discardableResult
    public func create<T: NSManagedObject>(
        _ type: T.Type,
        in context: NSManagedObjectContext? = nil,
        configure: (T) -> Void
    ) throws -> T {
        let ctx = context ?? stack.viewContext
        let object = T(context: ctx)
        configure(object)
        try save(context: ctx)
        return object
    }

    // MARK: - Read

    /// Выполняет fetch запрос.
    public func fetch<T: NSManagedObject>(
        _ type: T.Type,
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor] = [],
        limit: Int = 0,
        in context: NSManagedObjectContext? = nil
    ) throws -> [T] {
        let ctx = context ?? stack.viewContext
        let request = fetchRequest(for: type)
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors.isEmpty ? nil : sortDescriptors
        request.fetchLimit = limit
        return try ctx.fetch(request)
    }

    /// Возвращает первый объект, удовлетворяющий предикату.
    public func fetchFirst<T: NSManagedObject>(
        _ type: T.Type,
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor] = [],
        in context: NSManagedObjectContext? = nil
    ) throws -> T? {
        try fetch(type, predicate: predicate, sortDescriptors: sortDescriptors, limit: 1, in: context).first
    }

    /// Возвращает объект по NSManagedObjectID.
    public func object<T: NSManagedObject>(
        with id: NSManagedObjectID,
        in context: NSManagedObjectContext? = nil
    ) throws -> T? {
        let ctx = context ?? stack.viewContext
        return try ctx.existingObject(with: id) as? T
    }

    // MARK: - Update / Upsert

    /// Обновляет существующий объект по ключу или создаёт новый.
    @discardableResult
    public func upsert<T: NSManagedObject>(
        _ type: T.Type,
        idKey: String,
        idValue: CVarArg,
        in context: NSManagedObjectContext? = nil,
        configure: (T) -> Void
    ) throws -> T {
        let ctx = context ?? stack.viewContext
        let predicate = NSPredicate(format: "%K == %@", idKey, idValue)
        let existing = try fetchFirst(type, predicate: predicate, in: ctx)
        let object = existing ?? T(context: ctx)
        configure(object)
        try save(context: ctx)
        return object
    }

    // MARK: - Delete

    /// Удаляет объект.
    public func delete(
        _ object: NSManagedObject,
        in context: NSManagedObjectContext? = nil
    ) throws {
        let ctx = context ?? stack.viewContext
        let toDelete: NSManagedObject
        if object.managedObjectContext === ctx {
            toDelete = object
        } else {
            toDelete = try ctx.existingObject(with: object.objectID)
        }
        ctx.delete(toDelete)
        try save(context: ctx)
    }

    /// Удаляет все объекты указанного типа (с опциональным предикатом).
    public func deleteAll<T: NSManagedObject>(
        _ type: T.Type,
        predicate: NSPredicate? = nil,
        in context: NSManagedObjectContext? = nil
    ) throws {
        let ctx = context ?? stack.viewContext
        let entityName = entityName(for: type)
        let request = NSFetchRequest<NSManagedObjectID>(entityName: entityName)
        request.predicate = predicate
        request.resultType = .managedObjectIDResultType
        let ids = try ctx.fetch(request)
        ids.forEach { ctx.delete(ctx.object(with: $0)) }
        try save(context: ctx)
    }

    // MARK: - Save

    /// Сохраняет контекст.
    public func save(context: NSManagedObjectContext? = nil) throws {
        let ctx = context ?? stack.viewContext
        guard ctx.hasChanges else { return }
        try ctx.save()
    }

    // MARK: - Background

    /// Выполняет блок асинхронно в фоновом контексте.
    public func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let ctx = stack.newBackgroundContext()
        ctx.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        ctx.perform {
            block(ctx)
            if ctx.hasChanges { try? ctx.save() }
        }
    }

    /// Выполняет блок в фоновом контексте синхронно.
    public func performBackgroundTaskAndWait<T>(_ block: (NSManagedObjectContext) throws -> T) throws -> T {
        let ctx = stack.newBackgroundContext()
        ctx.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return try ctx.performAndWait {
            let result = try block(ctx)
            if ctx.hasChanges { try ctx.save() }
            return result
        }
    }

    // MARK: - Helpers

    private func fetchRequest<T: NSManagedObject>(for type: T.Type) -> NSFetchRequest<T> {
        NSFetchRequest<T>(entityName: entityName(for: type))
    }

    private func entityName<T: NSManagedObject>(for type: T.Type) -> String {
        let name = String(describing: type)
        if let dotIndex = name.firstIndex(of: ".") {
            return String(name[name.index(after: dotIndex)...])
        }
        return name
    }
}
