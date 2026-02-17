//
//  CoreDataStack.swift
//  Todo
//
//  Created by Aleksandr Lis on 16.02.2026.
//

import CoreData

public protocol ICoreDataStack {
    var viewContext: NSManagedObjectContext { get }

    func load(completion: ((Error?) -> Void)?)
    func newBackgroundContext() -> NSManagedObjectContext
    func saveViewContext() throws
}

public extension ICoreDataStack {
    func load() {
        load(completion: nil)
    }
}

public final class CoreDataStack {

    public let container: NSPersistentContainer

    public var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    public init(
        modelName: String,
        bundle: Bundle = .main,
        storeURL: URL? = nil,
        storeType: String = NSSQLiteStoreType,
        migrationOptions: Bool = true
    ) {
        guard let modelURL = bundle.url(forResource: modelName, withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL)
        else {
            fatalError("CoreData: модель '\(modelName)' не найдена в bundle \(bundle)")
        }
        container = NSPersistentContainer(name: modelName, managedObjectModel: model)

        if let storeURL {
            let description = NSPersistentStoreDescription(url: storeURL)
            description.type = storeType
            if migrationOptions {
                description.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
                description.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)
            }
            container.persistentStoreDescriptions = [description]
        }
    }
}

// MARK: - CoreDataStack

extension CoreDataStack: ICoreDataStack {
    public func load(completion: ((Error?) -> Void)? = nil) {
        container.loadPersistentStores { _, error in
            completion?(error)
        }
    }

    public func newBackgroundContext() -> NSManagedObjectContext {
        container.newBackgroundContext()
    }

    public func saveViewContext() throws {
        let context = viewContext
        guard context.hasChanges else { return }
        try context.save()
    }
}
