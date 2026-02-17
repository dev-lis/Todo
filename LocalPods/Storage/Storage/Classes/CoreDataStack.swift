//
//  CoreDataStack.swift
//  Todo
//
//  Created by Aleksandr Lis on 16.02.2026.
//

import CoreData

/// Стек Core Data: persistent container и контексты.
public final class CoreDataStack {

    public let container: NSPersistentContainer

    /// Контекст для UI (main queue).
    public var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    /// Инициализация по имени модели (.xcdatamodeld в бандле).
    public init(
        modelName: String = "Storage",
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

        let url = storeURL ?? FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("\(modelName).sqlite")
        let description = NSPersistentStoreDescription(url: url)
        description.type = storeType
        if migrationOptions {
            description.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
            description.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)
        }
        container.persistentStoreDescriptions = [description]
    }

    public func load(completion: ((Error?) -> Void)? = nil) {
        container.loadPersistentStores { _, error in
            completion?(error)
        }
    }

    /// Новый контекст для фоновых операций.
    public func newBackgroundContext() -> NSManagedObjectContext {
        container.newBackgroundContext()
    }

    /// Сохранение viewContext.
    public func saveViewContext() throws {
        let context = viewContext
        guard context.hasChanges else { return }
        try context.save()
    }
}
