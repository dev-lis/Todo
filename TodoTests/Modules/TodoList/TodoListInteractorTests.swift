//
//  TodoListInteractorTests.swift
//  TodoTests
//

import XCTest
@testable import Todo

final class TodoListInteractorTests: XCTestCase {

    private var todoListServiceMock: ITodoListServiceMock!
    private var outputMock: ITodoListInteractorOutputMock!
    private var sut: TodoListInteractor!

    override func setUpWithError() throws {
        try super.setUpWithError()
        todoListServiceMock = ITodoListServiceMock()
        outputMock = ITodoListInteractorOutputMock()
        sut = TodoListInteractor(todoListService: todoListServiceMock)
        sut.output = outputMock
    }

    override func tearDownWithError() throws {
        todoListServiceMock = nil
        outputMock = nil
        sut = nil
        try super.tearDownWithError()
    }

    // MARK: - fetchTodoList

    func test_fetchTodoList_callsServiceFetchTodoList() {
        sut.fetchTodoList()
        XCTAssertEqual(todoListServiceMock.fetchTodoListCallsCount, 1)
    }

    func test_fetchTodoList_onSuccess_callsOutputDidGetTodoList() {
        let list = TodoList(todos: [], total: 0, limit: 10)
        todoListServiceMock.fetchTodoListClosure = { $0(.success(list)) }

        sut.fetchTodoList()

        XCTAssertEqual(outputMock.didGetTodoListCallsCount, 1)
    }

    func test_fetchTodoList_onFailure_callsOutputDidGetError() {
        let error = NSError(domain: "test", code: -1, userInfo: nil)
        todoListServiceMock.fetchTodoListClosure = { $0(.failure(error)) }

        sut.fetchTodoList()

        XCTAssertEqual(outputMock.didGetErrorCallsCount, 1)
    }

    func test_fetchTodoList_success_forwardsTodoListToOutput() {
        let todo = Todo(id: "1", title: "Test", description: "D", date: Date(), isCompleted: false)
        let list = TodoList(todos: [todo], total: 1, limit: 10)
        var capturedList: TodoList?
        outputMock.didGetTodoListClosure = { capturedList = $0 }
        todoListServiceMock.fetchTodoListClosure = { $0(.success(list)) }

        sut.fetchTodoList()

        XCTAssertEqual(capturedList?.total, 1)
        XCTAssertEqual(capturedList?.todos.first?.title, "Test")
    }

    // MARK: - updateTodo

    func test_updateTodo_callsServiceUpdateTodo() {
        let todo = Todo(id: "1", title: "T", description: "D", date: Date(), isCompleted: false)

        sut.updateTodo(todo)

        XCTAssertEqual(todoListServiceMock.updateTodoCallsCount, 1)
    }

    func test_updateTodo_forwardsTodoToService() {
        let todo = Todo(id: "2", title: "Title", description: "Desc", date: Date(), isCompleted: true)
        var capturedTodo: Todo?
        todoListServiceMock.updateTodoClosure = { capturedTodo = $0 }

        sut.updateTodo(todo)

        XCTAssertEqual(capturedTodo?.id, 2)
        XCTAssertEqual(capturedTodo?.title, "Title")
        XCTAssertEqual(capturedTodo?.isCompleted, true)
    }
}
