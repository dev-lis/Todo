//
//  TodoListServiceTests.swift
//  TodoTests
//

import XCTest
import CoreData
import Network
import Storage
@testable import Todo

// MARK: - Stub ITodoListToEntityMapper (Core Data — не в генерации моков)

private final class StubTodoListToEntityMapper: ITodoListToEntityMapper {
    func map(dto: TodoList, context: NSManagedObjectContext) throws -> TodoListEntity {
        throw NSError(domain: "test", code: 0, userInfo: nil)
    }
}

// MARK: - Mock INetworkService

private final class MockNetworkService: INetworkService {
    var requestCompletion: ((Result<TodoList, Error>) -> Void)?
    func request<T: Decodable>(_ request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        requestCompletion = { result in
            completion(result as! Result<T, Error>)
        }
    }
}

// MARK: - Stub ICoreDataRepository (no Core Data assertions, only for DI)

private final class StubCoreDataRepository: ICoreDataRepository {
    func create<T: NSManagedObject>(_ type: T.Type, in context: NSManagedObjectContext?, configure: (T) -> Void) throws -> T {
        fatalError("Stub: not used in these tests")
    }

    func fetch<T: NSManagedObject>(_ type: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor], limit: Int, in context: NSManagedObjectContext?) throws -> [T] {
        []
    }

    func fetchFirst<T: NSManagedObject>(_ type: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor], in context: NSManagedObjectContext?) throws -> T? {
        nil
    }

    func fetchFirst<T: NSManagedObject>(_ type: T.Type, in context: NSManagedObjectContext?) throws -> T? {
        nil
    }

    func object<T: NSManagedObject>(with id: NSManagedObjectID, in context: NSManagedObjectContext?) throws -> T? {
        nil
    }

    func upsert<T: NSManagedObject>(_ type: T.Type, idKey: String, idValue: CVarArg, in context: NSManagedObjectContext?, configure: (T) -> Void) throws -> T {
        fatalError("Stub: not used in these tests")
    }

    func delete(_ object: NSManagedObject, in context: NSManagedObjectContext?) throws {}

    func deleteAll<T: NSManagedObject>(_ type: T.Type, predicate: NSPredicate?, in context: NSManagedObjectContext?) throws {}

    func save(context: NSManagedObjectContext?) throws {}

    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {}

    func performBackgroundTaskAndWait<T>(_ block: (NSManagedObjectContext) throws -> T) throws -> T {
        fatalError("Stub: not used in these tests")
    }
}

// MARK: - TodoListServiceTests (network/request only; no Core Data behaviour tested)

final class TodoListServiceTests: XCTestCase {

    private var networkMock: MockNetworkService!
    private var requestBuilderMock: ITodoRequestBuilderMock!
    private var repositoryStub: StubCoreDataRepository!
    private var todoListToEntityMapper: StubTodoListToEntityMapper!
    private var todoListEntityToDTOMapper: TodoListEntityToDTOMapper!
    private var sut: TodoListService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        networkMock = MockNetworkService()
        requestBuilderMock = ITodoRequestBuilderMock()
        repositoryStub = StubCoreDataRepository()
        todoListToEntityMapper = StubTodoListToEntityMapper()
        todoListEntityToDTOMapper = TodoListEntityToDTOMapper()
        sut = TodoListService(
            networkService: networkMock,
            requestBuilder: requestBuilderMock,
            coreDataRepository: repositoryStub,
            todoListToEntityMapper: todoListToEntityMapper,
            todoListEntityToDTOMapper: todoListEntityToDTOMapper
        )
    }

    override func tearDownWithError() throws {
        networkMock = nil
        requestBuilderMock = nil
        repositoryStub = nil
        todoListToEntityMapper = nil
        todoListEntityToDTOMapper = nil
        sut = nil
        try super.tearDownWithError()
    }

    // MARK: - fetchTodoList (network + request builder only)

    func test_fetchTodoList_whenRequestBuilderThrows_callsCompletionWithFailure() {
        requestBuilderMock.todoListdRequestClosure = { throw NSError(domain: "test", code: -2, userInfo: nil) }

        let exp = expectation(description: "completion")
        var result: Result<TodoList, Error>?
        sut.fetchTodoList { res in
            result = res
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)

        guard case .failure(let err) = result else {
            XCTFail("Expected failure"); return
        }
        XCTAssertEqual((err as NSError).code, -2)
    }

    func test_fetchTodoList_whenNetworkSucceeds_callsCompletionWithSuccess() {
        requestBuilderMock.todoListdRequestReturnValue = URLRequest(url: URL(string: "https://example.com")!)
        let list = TodoList(todos: [], total: 5, limit: 10)

        let exp = expectation(description: "completion")
        var result: Result<TodoList, Error>?
        sut.fetchTodoList { res in
            result = res
            exp.fulfill()
        }
        // Service uses queue.async; trigger network response after queue runs
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.05) { [weak networkMock] in
            networkMock?.requestCompletion?(.success(list))
        }
        wait(for: [exp], timeout: 1)

        guard case .success(let todoList) = result else {
            XCTFail("Expected success"); return
        }
        XCTAssertEqual(todoList.total, 5)
    }

    func test_fetchTodoList_whenNetworkFails_callsCompletionWithFailure() {
        requestBuilderMock.todoListdRequestReturnValue = URLRequest(url: URL(string: "https://example.com")!)
        let error = NSError(domain: "network", code: -3, userInfo: nil)

        let exp = expectation(description: "completion")
        var result: Result<TodoList, Error>?
        sut.fetchTodoList { res in
            result = res
            exp.fulfill()
        }
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.05) { [weak networkMock] in
            networkMock?.requestCompletion?(.failure(error))
        }
        wait(for: [exp], timeout: 1)

        guard case .failure(let err) = result else {
            XCTFail("Expected failure"); return
        }
        XCTAssertEqual((err as NSError).code, -3)
    }

    func test_fetchTodoList_callsRequestBuilder() {
        requestBuilderMock.todoListdRequestReturnValue = URLRequest(url: URL(string: "https://example.com")!)
        let exp = expectation(description: "completion")
        sut.fetchTodoList { _ in exp.fulfill() }
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.05) { [weak networkMock] in
            networkMock?.requestCompletion?(.success(TodoList(todos: [], total: 0, limit: 10)))
        }
        wait(for: [exp], timeout: 1)

        XCTAssertEqual(requestBuilderMock.todoListdRequestCallsCount, 1)
    }
}
