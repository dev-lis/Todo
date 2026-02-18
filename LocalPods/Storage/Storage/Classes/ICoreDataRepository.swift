//
//  ICoreDataRepository.swift
//  Storage
//
//  Created by Aleksandr Lis on 17.02.2026.
//

import CoreData

public protocol ICoreDataRepository {
    func create<T: NSManagedObject>(
        _ type: T.Type,
        in context: NSManagedObjectContext?,
        configure: (T) -> Void
    ) throws -> T

    func fetch<T: NSManagedObject>(
        _ type: T.Type,
        predicate: NSPredicate?,
        sortDescriptors: [NSSortDescriptor],
        limit: Int,
        in context: NSManagedObjectContext?
    ) throws -> [T]

    func fetchFirst<T: NSManagedObject>(
        _ type: T.Type,
        predicate: NSPredicate?,
        sortDescriptors: [NSSortDescriptor],
        in context: NSManagedObjectContext?
    ) throws -> T?

    func object<T: NSManagedObject>(
        with id: NSManagedObjectID,
        in context: NSManagedObjectContext?
    ) throws -> T?

    @discardableResult
    func upsert<T: NSManagedObject>(
        _ type: T.Type,
        idKey: String,
        idValue: CVarArg,
        in context: NSManagedObjectContext?,
        configure: (T) -> Void
    ) throws -> T

    func delete(
        _ object: NSManagedObject,
        in context: NSManagedObjectContext?
    ) throws

    func deleteAll<T: NSManagedObject>(
        _ type: T.Type,
        predicate: NSPredicate?,
        in context: NSManagedObjectContext?
    ) throws

    func save(context: NSManagedObjectContext?) throws

    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void)

    func performBackgroundTaskAndWait<T>(_ block: (NSManagedObjectContext) throws -> T) throws -> T
}

public extension ICoreDataRepository {
    @discardableResult
    func create<T: NSManagedObject>(_ type: T.Type, configure: (T) -> Void) throws -> T {
        try create(type, in: nil, configure: configure)
    }

    func fetch<T: NSManagedObject>(_ type: T.Type) throws -> [T] {
        try fetch(type, predicate: nil, sortDescriptors: [], limit: 0, in: nil)
    }

    func fetch<T: NSManagedObject>(_ type: T.Type, in context: NSManagedObjectContext?) throws -> [T] {
        try fetch(type, predicate: nil, sortDescriptors: [], limit: 0, in: context)
    }

    func fetch<T: NSManagedObject>(_ type: T.Type, predicate: NSPredicate?) throws -> [T] {
        try fetch(type, predicate: predicate, sortDescriptors: [], limit: 0, in: nil)
    }

    func fetch<T: NSManagedObject>(_ type: T.Type, predicate: NSPredicate?, in context: NSManagedObjectContext?) throws -> [T] {
        try fetch(type, predicate: predicate, sortDescriptors: [], limit: 0, in: context)
    }

    func fetch<T: NSManagedObject>(_ type: T.Type, sortDescriptors: [NSSortDescriptor]) throws -> [T] {
        try fetch(type, predicate: nil, sortDescriptors: sortDescriptors, limit: 0, in: nil)
    }

    func fetch<T: NSManagedObject>(_ type: T.Type, sortDescriptors: [NSSortDescriptor], in context: NSManagedObjectContext?) throws -> [T] {
        try fetch(type, predicate: nil, sortDescriptors: sortDescriptors, limit: 0, in: context)
    }

    func fetch<T: NSManagedObject>(_ type: T.Type, limit: Int) throws -> [T] {
        try fetch(type, predicate: nil, sortDescriptors: [], limit: limit, in: nil)
    }

    func fetch<T: NSManagedObject>(_ type: T.Type, limit: Int, in context: NSManagedObjectContext?) throws -> [T] {
        try fetch(type, predicate: nil, sortDescriptors: [], limit: limit, in: context)
    }

    func fetch<T: NSManagedObject>(_ type: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]) throws -> [T] {
        try fetch(type, predicate: predicate, sortDescriptors: sortDescriptors, limit: 0, in: nil)
    }

    func fetch<T: NSManagedObject>(_ type: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor], in context: NSManagedObjectContext?) throws -> [T] {
        try fetch(type, predicate: predicate, sortDescriptors: sortDescriptors, limit: 0, in: context)
    }

    func fetch<T: NSManagedObject>(_ type: T.Type, predicate: NSPredicate?, limit: Int) throws -> [T] {
        try fetch(type, predicate: predicate, sortDescriptors: [], limit: limit, in: nil)
    }

    func fetch<T: NSManagedObject>(_ type: T.Type, predicate: NSPredicate?, limit: Int, in context: NSManagedObjectContext?) throws -> [T] {
        try fetch(type, predicate: predicate, sortDescriptors: [], limit: limit, in: context)
    }

    func fetch<T: NSManagedObject>(_ type: T.Type, sortDescriptors: [NSSortDescriptor], limit: Int) throws -> [T] {
        try fetch(type, predicate: nil, sortDescriptors: sortDescriptors, limit: limit, in: nil)
    }

    func fetch<T: NSManagedObject>(_ type: T.Type, sortDescriptors: [NSSortDescriptor], limit: Int, in context: NSManagedObjectContext?) throws -> [T] {
        try fetch(type, predicate: nil, sortDescriptors: sortDescriptors, limit: limit, in: context)
    }

    func fetch<T: NSManagedObject>(_ type: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor], limit: Int) throws -> [T] {
        try fetch(type, predicate: predicate, sortDescriptors: sortDescriptors, limit: limit, in: nil)
    }

    func fetchFirst<T: NSManagedObject>(_ type: T.Type) throws -> T? {
        try fetchFirst(type, predicate: nil, sortDescriptors: [], in: nil)
    }

    func fetchFirst<T: NSManagedObject>(_ type: T.Type, in context: NSManagedObjectContext?) throws -> T? {
        try fetchFirst(type, predicate: nil, sortDescriptors: [], in: context)
    }

    func fetchFirst<T: NSManagedObject>(_ type: T.Type, predicate: NSPredicate?) throws -> T? {
        try fetchFirst(type, predicate: predicate, sortDescriptors: [], in: nil)
    }

    func fetchFirst<T: NSManagedObject>(_ type: T.Type, predicate: NSPredicate?, in context: NSManagedObjectContext?) throws -> T? {
        try fetchFirst(type, predicate: predicate, sortDescriptors: [], in: context)
    }

    func fetchFirst<T: NSManagedObject>(_ type: T.Type, sortDescriptors: [NSSortDescriptor]) throws -> T? {
        try fetchFirst(type, predicate: nil, sortDescriptors: sortDescriptors, in: nil)
    }

    func fetchFirst<T: NSManagedObject>(_ type: T.Type, sortDescriptors: [NSSortDescriptor], in context: NSManagedObjectContext?) throws -> T? {
        try fetchFirst(type, predicate: nil, sortDescriptors: sortDescriptors, in: context)
    }

    func fetchFirst<T: NSManagedObject>(_ type: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]) throws -> T? {
        try fetchFirst(type, predicate: predicate, sortDescriptors: sortDescriptors, in: nil)
    }

    func object<T: NSManagedObject>(with id: NSManagedObjectID) throws -> T? {
        try object(with: id, in: nil)
    }

    @discardableResult
    func upsert<T: NSManagedObject>(
        _ type: T.Type,
        idKey: String,
        idValue: CVarArg,
        configure: (T) -> Void
    ) throws -> T {
        try upsert(type, idKey: idKey, idValue: idValue, in: nil, configure: configure)
    }

    func delete(_ object: NSManagedObject) throws {
        try delete(object, in: nil)
    }

    func deleteAll<T: NSManagedObject>(_ type: T.Type) throws {
        try deleteAll(type, predicate: nil, in: nil)
    }

    func deleteAll<T: NSManagedObject>(_ type: T.Type, predicate: NSPredicate?) throws {
        try deleteAll(type, predicate: predicate, in: nil)
    }

    func deleteAll<T: NSManagedObject>(_ type: T.Type, in context: NSManagedObjectContext?) throws {
        try deleteAll(type, predicate: nil, in: context)
    }

    func save() throws {
        try save(context: nil)
    }
}
