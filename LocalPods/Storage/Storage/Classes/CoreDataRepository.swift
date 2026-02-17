//
//  CoreDataRepository.swift
//  Storage
//
//  Created by Aleksandr Lis on 16.02.2026.
//

import CoreData

public final class CoreDataRepository {

    private let stack: ICoreDataStack

    public init(stack: ICoreDataStack) {
        self.stack = stack
    }
}

private extension CoreDataRepository {
    func fetchRequest<T: NSManagedObject>(for type: T.Type) -> NSFetchRequest<T> {
        NSFetchRequest<T>(entityName: entityName(for: type))
    }

    func entityName<T: NSManagedObject>(for type: T.Type) -> String {
        let name = String(describing: type)
        if let dotIndex = name.firstIndex(of: ".") {
            return String(name[name.index(after: dotIndex)...])
        }
        return name
    }

    // swiftlint:disable identifier_name
    func objectForPredicate(_ value: CVarArg) -> NSObject {
        switch value {
        case let n as Int:
            return NSNumber(value: n)
        case let n as Int64:
            return NSNumber(value: n)
        case let n as Int32:
            return NSNumber(value: n)
        case let b as Bool:
            return NSNumber(value: b)
        case let s as String:
            return s as NSString
        case let o as NSObject:
            return o
        default:
            return String(describing: value) as NSString
        }
    }
    // swiftlint:enable identifier_name
}

// MARK: - ICoreDataRepository

extension CoreDataRepository: ICoreDataRepository {
    @discardableResult
    public func create<T: NSManagedObject>(
        _ type: T.Type,
        in context: NSManagedObjectContext?,
        configure: (T) -> Void
    ) throws -> T {
        let ctx = context ?? stack.viewContext
        let object = T(context: ctx)
        configure(object)
        try save(context: ctx)
        return object
    }

    public func fetch<T: NSManagedObject>(
        _ type: T.Type,
        predicate: NSPredicate?,
        sortDescriptors: [NSSortDescriptor],
        limit: Int = 0,
        in context: NSManagedObjectContext?
    ) throws -> [T] {
        let ctx = context ?? stack.viewContext
        let request = fetchRequest(for: type)
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors.isEmpty ? nil : sortDescriptors
        request.fetchLimit = limit
        return try ctx.fetch(request)
    }

    public func fetchFirst<T: NSManagedObject>(
        _ type: T.Type,
        predicate: NSPredicate?,
        sortDescriptors: [NSSortDescriptor],
        in context: NSManagedObjectContext?
    ) throws -> T? {
        try fetch(type, predicate: predicate, sortDescriptors: sortDescriptors, limit: 1, in: context).first
    }

    public func object<T: NSManagedObject>(
        with id: NSManagedObjectID,
        in context: NSManagedObjectContext?
    ) throws -> T? {
        let ctx = context ?? stack.viewContext
        return try ctx.existingObject(with: id) as? T
    }

    @discardableResult
    public func upsert<T: NSManagedObject>(
        _ type: T.Type,
        idKey: String,
        idValue: CVarArg,
        in context: NSManagedObjectContext?,
        configure: (T) -> Void
    ) throws -> T {
        let ctx = context ?? stack.viewContext
        let objectValue = objectForPredicate(idValue)
        let predicate = NSPredicate(format: "%K == %@", idKey, objectValue)
        let existing = try fetchFirst(type, predicate: predicate, sortDescriptors: [], in: ctx)
        let object = existing ?? T(context: ctx)
        configure(object)
        try save(context: ctx)
        return object
    }

    public func delete(
        _ object: NSManagedObject,
        in context: NSManagedObjectContext?
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

    public func deleteAll<T: NSManagedObject>(
        _ type: T.Type,
        predicate: NSPredicate?,
        in context: NSManagedObjectContext?
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

    public func save(context: NSManagedObjectContext?) throws {
        let ctx = context ?? stack.viewContext
        guard ctx.hasChanges else { return }
        try ctx.save()
    }

    public func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let ctx = stack.newBackgroundContext()
        ctx.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        ctx.perform {
            block(ctx)
            if ctx.hasChanges { try? ctx.save() }
        }
    }

    public func performBackgroundTaskAndWait<T>(_ block: (NSManagedObjectContext) throws -> T) throws -> T {
        let ctx = stack.newBackgroundContext()
        ctx.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return try ctx.performAndWait {
            let result = try block(ctx)
            if ctx.hasChanges { try ctx.save() }
            return result
        }
    }
}
