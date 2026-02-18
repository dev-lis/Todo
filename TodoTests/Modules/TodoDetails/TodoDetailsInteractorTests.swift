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
        serviceMock.fetch_todo_id_completion_closure = { _, completion in completion(.success(self.makeTodo())) }

        sut.fetchTodo(by: "id-1")

        XCTAssertEqual(serviceMock.fetch_todo_id_completion_calls_count, 1)
    }

    func test_fetchTodo_forwardsIdToService() {
        var capturedId: String?
        serviceMock.fetch_todo_id_completion_closure = { id, completion in
            capturedId = id
            completion(.success(self.makeTodo()))
        }

        sut.fetchTodo(by: "todo-42")

        XCTAssertEqual(capturedId, "todo-42")
    }

    func test_fetchTodo_onSuccess_callsOutputDidGetTodo() {
        let todo = makeTodo(id: "1", title: "Test", description: "Desc")
        serviceMock.fetch_todo_id_completion_closure = { _, completion in completion(.success(todo)) }

        sut.fetchTodo(by: "1")

        XCTAssertEqual(outputMock.did_get_todo_todo_calls_count, 1)
    }

    func test_fetchTodo_onSuccess_forwardsTodoToOutput() {
        let todo = makeTodo(id: "2", title: "Title", description: "Description")
        var capturedTodo: Todo?
        outputMock.did_get_todo_todo_closure = { capturedTodo = $0 }
        serviceMock.fetch_todo_id_completion_closure = { _, completion in completion(.success(todo)) }

        sut.fetchTodo(by: "2")

        XCTAssertEqual(capturedTodo?.id, "2")
        XCTAssertEqual(capturedTodo?.title, "Title")
        XCTAssertEqual(capturedTodo?.description, "Description")
    }

    func test_fetchTodo_onFailure_callsOutputDidGetError() {
        let error = NSError(domain: "test", code: -1, userInfo: nil)
        serviceMock.fetch_todo_id_completion_closure = { _, completion in completion(.failure(error)) }

        sut.fetchTodo(by: "1")

        XCTAssertEqual(outputMock.did_get_error_error_calls_count, 1)
    }

    // MARK: - saveTodo(_:)

    func test_saveTodo_callsServiceSaveTodo() {
        let todo = makeTodo()
        serviceMock.save_todo_todo_completion_closure = { _, completion in completion(.success(())) }

        sut.saveTodo(todo)

        XCTAssertEqual(serviceMock.save_todo_todo_completion_calls_count, 1)
    }

    func test_saveTodo_forwardsTodoToService() {
        let todo = makeTodo(id: "3", title: "Save", description: "Text")
        var capturedTodo: Todo?
        serviceMock.save_todo_todo_completion_closure = { todo, completion in
            capturedTodo = todo
            completion(.success(()))
        }

        sut.saveTodo(todo)

        XCTAssertEqual(capturedTodo?.id, "3")
        XCTAssertEqual(capturedTodo?.title, "Save")
    }

    func test_saveTodo_onSuccess_callsOutputDidSaveTodo() {
        serviceMock.save_todo_todo_completion_closure = { _, completion in completion(.success(())) }

        sut.saveTodo(makeTodo())

        XCTAssertEqual(outputMock.did_save_todo_calls_count, 1)
    }

    func test_saveTodo_onFailure_callsOutputDidGetError() {
        let error = NSError(domain: "test", code: -2, userInfo: nil)
        serviceMock.save_todo_todo_completion_closure = { _, completion in completion(.failure(error)) }

        sut.saveTodo(makeTodo())

        XCTAssertEqual(outputMock.did_get_error_error_calls_count, 1)
    }

    private func makeTodo(id: String = "id", title: String = "Title", description: String = "Desc") -> Todo {
        Todo(id: id, title: title, description: description, date: Date(), isCompleted: false)
    }
}
