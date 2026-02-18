//
//  TodoDetailsServiceTests.swift
//  TodoTests
//

import XCTest
import CoreData
import Storage
@testable import Todo

// MARK: - Mock ICoreDataRepository for TodoDetailsService

private final class MockTodoDetailsRepository: ICoreDataRepository {
    var fetchFirstError: Error?
    var fetchFirstTodoListEntityResult: TodoListEntity?
    var fetchFirstTodoEntityResult: TodoEntity?
    var createError: Error?
    var upsertCallCount = 0
    var upsertError: Error?

    func create<T: NSManagedObject>(_ type: T.Type, in context: NSManagedObjectContext?, configure: (T) -> Void) throws -> T {
        if let createError { throw createError }
        fatalError("Mock create without context")
    }

    func fetch<T: NSManagedObject>(_ type: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor], limit: Int, in context: NSManagedObjectContext?) throws -> [T] {
        []
    }

    func fetchFirst<T: NSManagedObject>(_ type: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor], in context: NSManagedObjectContext?) throws -> T? {
        if let fetchFirstError { throw fetchFirstError }
        if type is TodoEntity.Type, let entity = fetchFirstTodoEntityResult as? T {
            return entity
        }
        return nil
    }

    func fetchFirst<T: NSManagedObject>(_ type: T.Type, in context: NSManagedObjectContext?) throws -> T? {
        if let fetchFirstError { throw fetchFirstError }
        if type is TodoListEntity.Type, let entity = fetchFirstTodoListEntityResult as? T {
            return entity
        }
        return nil
    }

    func object<T: NSManagedObject>(with id: NSManagedObjectID, in context: NSManagedObjectContext?) throws -> T? {
        nil
    }

    func upsert<T: NSManagedObject>(_ type: T.Type, idKey: String, idValue: CVarArg, in context: NSManagedObjectContext?, configure: (T) -> Void) throws -> T {
        upsertCallCount += 1
        if let upsertError { throw upsertError }
        fatalError("Mock upsert cannot return entity without context")
    }

    func delete(_ object: NSManagedObject, in context: NSManagedObjectContext?) throws {}

    func deleteAll<T: NSManagedObject>(_ type: T.Type, predicate: NSPredicate?, in context: NSManagedObjectContext?) throws {}

    func save(context: NSManagedObjectContext?) throws {}

    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {}

    func performBackgroundTaskAndWait<T>(_ block: (NSManagedObjectContext) throws -> T) throws -> T {
        fatalError("Not used")
    }
}

// MARK: - Mock ITodoListToEntityMapper

private final class MockTodoListToEntityMapper: ITodoListToEntityMapper {
    func map(dto: TodoList, context: NSManagedObjectContext) throws -> TodoListEntity {
        fatalError("Not used in TodoDetailsService tests")
    }
}

// MARK: - TodoDetailsServiceTests

final class TodoDetailsServiceTests: XCTestCase {

    private var repositoryMock: MockTodoDetailsRepository!
    private var todoListToEntityMapper: MockTodoListToEntityMapper!
    private var todoListEntityToDTOMapper: TodoListEntityToDTOMapper!
    private var todoEntityToDTOMapper: TodoEntityToDTOMapper!
    private var sut: TodoDetailsService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        repositoryMock = MockTodoDetailsRepository()
        todoListToEntityMapper = MockTodoListToEntityMapper()
        todoListEntityToDTOMapper = TodoListEntityToDTOMapper()
        todoEntityToDTOMapper = TodoEntityToDTOMapper()
        sut = TodoDetailsService(
            coreDataRepository: repositoryMock,
            todoListToEntityMapper: todoListToEntityMapper,
            todoListEntityToDTOMapper: todoListEntityToDTOMapper,
            todoEntityToDTOMapper: todoEntityToDTOMapper
        )
    }

    override func tearDownWithError() throws {
        repositoryMock = nil
        todoListToEntityMapper = nil
        todoListEntityToDTOMapper = nil
        todoEntityToDTOMapper = nil
        sut = nil
        try super.tearDownWithError()
    }

    // MARK: - fetchTodo

    func test_fetchTodo_whenFetchFirstThrows_callsCompletionWithFailure() {
        repositoryMock.fetchFirstError = NSError(domain: "test", code: -1, userInfo: nil)

        let exp = expectation(description: "completion")
        var result: Result<Todo, Error>?
        sut.fetchTodo(by: "1") { res in
            result = res
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)

        guard case .failure(let error) = result else {
            XCTFail("Expected failure"); return
        }
        XCTAssertEqual((error as NSError).code, -1)
    }

    func test_fetchTodo_whenFetchFirstReturnsNil_callsCompletionWithTodoNotFound() {
        repositoryMock.fetchFirstError = nil
        repositoryMock.fetchFirstTodoEntityResult = nil

        let exp = expectation(description: "completion")
        var result: Result<Todo, Error>?
        sut.fetchTodo(by: "missing-id") { res in
            result = res
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)

        guard case .failure(let error) = result else {
            XCTFail("Expected failure"); return
        }
        guard case TodoDetailsError.todoNotFound(let id) = error else {
            XCTFail("Expected todoNotFound, got \(error)"); return
        }
        XCTAssertEqual(id, "missing-id")
    }

    func test_saveTodo_whenFetchFirstForListThrows_callsCompletionWithFailure() {
        repositoryMock.fetchFirstError = NSError(domain: "test", code: -2, userInfo: nil)
        let todo = Todo(id: "1", title: "T", description: "D", date: Date(), isCompleted: false)

        let exp = expectation(description: "completion")
        var result: Result<Void, Error>?
        sut.saveTodo(todo) { res in
            result = res
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)

        guard case .failure(let error) = result else {
            XCTFail("Expected failure"); return
        }
        XCTAssertEqual((error as NSError).code, -2)
    }

    func test_saveTodo_whenCreateThrows_callsCompletionWithFailure() {
        repositoryMock.fetchFirstError = nil
        repositoryMock.fetchFirstTodoListEntityResult = nil
        repositoryMock.createError = NSError(domain: "test", code: -3, userInfo: nil)

        let exp = expectation(description: "completion")
        var result: Result<Void, Error>?
        sut.saveTodo(Todo(id: "1", title: "T", description: "D", date: Date(), isCompleted: false)) { res in
            result = res
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)

        guard case .failure(let error) = result else {
            XCTFail("Expected failure"); return
        }
        XCTAssertEqual((error as NSError).code, -3)
    }
}
