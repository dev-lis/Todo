//
//  TodoDetailsInteractorTests.swift
//  TodoTests
//

import XCTest
@testable import Todo

final class TodoDetailsInteractorTests: XCTestCase {

    private var serviceMock: ITodoDetailsServiceMock!
    private var outputMock: ITodoDetailsInteractorOutputMock!
    private var sut: TodoDetailsInteractor!

    override func setUpWithError() throws {
        try super.setUpWithError()
        serviceMock = ITodoDetailsServiceMock()
        outputMock = ITodoDetailsInteractorOutputMock()
        sut = TodoDetailsInteractor(todoDetailsService: serviceMock)
        sut.output = outputMock
    }

    override func tearDownWithError() throws {
        serviceMock = nil
        outputMock = nil
        sut = nil
        try super.tearDownWithError()
    }

    // MARK: - fetchTodo(by:)

    func test_fetchTodo_callsServiceFetchTodo() {
        serviceMock.fetchTodo_id_completionClosure = { _, completion in completion(.success(self.makeTodo())) }

        sut.fetchTodo(by: "id-1")

        XCTAssertEqual(serviceMock.fetchTodo_id_completionCallsCount, 1)
    }

    func test_fetchTodo_forwardsIdToService() {
        var capturedId: String?
        serviceMock.fetchTodo_id_completionClosure = { id, completion in
            capturedId = id
            completion(.success(self.makeTodo()))
        }

        sut.fetchTodo(by: "todo-42")

        XCTAssertEqual(capturedId, "todo-42")
    }

    func test_fetchTodo_onSuccess_callsOutputDidGetTodo() {
        let todo = makeTodo(id: "1", title: "Test", description: "Desc")
        serviceMock.fetchTodo_id_completionClosure = { _, completion in completion(.success(todo)) }

        sut.fetchTodo(by: "1")

        XCTAssertEqual(outputMock.didGetTodo_todoCallsCount, 1)
    }

    func test_fetchTodo_onSuccess_forwardsTodoToOutput() {
        let todo = makeTodo(id: "2", title: "Title", description: "Description")
        var capturedTodo: Todo?
        outputMock.didGetTodo_todoClosure = { capturedTodo = $0 }
        serviceMock.fetchTodo_id_completionClosure = { _, completion in completion(.success(todo)) }

        sut.fetchTodo(by: "2")

        XCTAssertEqual(capturedTodo?.id, "2")
        XCTAssertEqual(capturedTodo?.title, "Title")
        XCTAssertEqual(capturedTodo?.description, "Description")
    }

    func test_fetchTodo_onFailure_callsOutputDidGetError() {
        let error = NSError(domain: "test", code: -1, userInfo: nil)
        serviceMock.fetchTodo_id_completionClosure = { _, completion in completion(.failure(error)) }

        sut.fetchTodo(by: "1")

        XCTAssertEqual(outputMock.didGetError_errorCallsCount, 1)
    }

    // MARK: - saveTodo(_:)

    func test_saveTodo_callsServiceSaveTodo() {
        let todo = makeTodo()
        serviceMock.saveTodo_todo_completionClosure = { _, completion in completion(.success(())) }

        sut.saveTodo(todo)

        XCTAssertEqual(serviceMock.saveTodo_todo_completionCallsCount, 1)
    }

    func test_saveTodo_forwardsTodoToService() {
        let todo = makeTodo(id: "3", title: "Save", description: "Text")
        var capturedTodo: Todo?
        serviceMock.saveTodo_todo_completionClosure = { todo, completion in
            capturedTodo = todo
            completion(.success(()))
        }

        sut.saveTodo(todo)

        XCTAssertEqual(capturedTodo?.id, "3")
        XCTAssertEqual(capturedTodo?.title, "Save")
    }

    func test_saveTodo_onSuccess_callsOutputDidSaveTodo() {
        serviceMock.saveTodo_todo_completionClosure = { _, completion in completion(.success(())) }

        sut.saveTodo(makeTodo())

        XCTAssertEqual(outputMock.didSaveTodoCallsCount, 1)
    }

    func test_saveTodo_onFailure_callsOutputDidGetError() {
        let error = NSError(domain: "test", code: -2, userInfo: nil)
        serviceMock.saveTodo_todo_completionClosure = { _, completion in completion(.failure(error)) }

        sut.saveTodo(makeTodo())

        XCTAssertEqual(outputMock.didGetError_errorCallsCount, 1)
    }

    private func makeTodo(id: String = "id", title: String = "Title", description: String = "Desc") -> Todo {
        Todo(id: id, title: title, description: description, date: Date(), isCompleted: false)
    }
}
