//
//  TodoListPresenterTests.swift
//  TodoTests
//

import XCTest
import AppUIKit
@testable import Todo

// MARK: - Mock IDateFormatter

private final class MockDateFormatter: IDateFormatter {
    var formattedDate: String = "formatted_date"
    func todoDateString(from date: Date) -> String { formattedDate }
}

// MARK: - TodoListPresenterTests

final class TodoListPresenterTests: XCTestCase {

    private var interactorMock: ITodoListInteractorInputMock!
    private var routerMock: ITodoListRouterMock!
    private var viewMock: ITodoListViewMock!
    private var dateFormatter: MockDateFormatter!
    private var sut: TodoListPresenter!

    override func setUpWithError() throws {
        try super.setUpWithError()
        interactorMock = ITodoListInteractorInputMock()
        routerMock = ITodoListRouterMock()
        viewMock = ITodoListViewMock()
        dateFormatter = MockDateFormatter()
        sut = TodoListPresenter(
            interactor: interactorMock,
            router: routerMock,
            dateFormatter: dateFormatter
        )
        sut.view = viewMock
    }

    override func tearDownWithError() throws {
        interactorMock = nil
        routerMock = nil
        viewMock = nil
        dateFormatter = nil
        sut = nil
        try super.tearDownWithError()
    }

    // MARK: - viewDidLoad

    func test_viewDidLoad_callsInteractorFetchTodoList() {
        sut.viewWillAppear()
        XCTAssertEqual(interactorMock.fetch_todo_list_calls_count, 1)
    }

    // MARK: - didGetTodoList (handleTodoList)

    func test_didGetTodoList_callsUpdateListAndUpdateCounter() {
        let todo = makeTodo(id: "1", title: "T", date: Date())
        let list = TodoList(todos: [todo], total: 1, limit: 10)

        sut.didGetTodoList(list)

        XCTAssertEqual(viewMock.update_list_items_calls_count, 1)
        XCTAssertEqual(viewMock.update_counter_count_calls_count, 1)
    }

    func test_didGetTodoList_passesTotalToUpdateCounter() {
        let list = TodoList(todos: [], total: 42, limit: 10)
        var capturedCount: Int?
        viewMock.update_counter_count_closure = { capturedCount = $0 }

        sut.didGetTodoList(list)

        XCTAssertEqual(capturedCount, 42)
    }

    func test_didGetTodoList_sortsTodosByDateDescending() {
        let older = Date(timeIntervalSince1970: 100)
        let newer = Date(timeIntervalSince1970: 200)
        let list = TodoList(
            todos: [
                makeTodo(id: "1", title: "Older", date: older),
                makeTodo(id: "2", title: "Newer", date: newer)
            ],
            total: 2,
            limit: 10
        )
        var capturedItems: [TodoDisplayItem]?
        viewMock.update_list_items_closure = { capturedItems = $0 }

        sut.didGetTodoList(list)

        XCTAssertEqual(capturedItems?.count, 2)
        XCTAssertEqual(capturedItems?.first?.title, "Newer")
        XCTAssertEqual(capturedItems?.last?.title, "Older")
    }

    func test_didGetTodoList_usesDateFormatterForDisplayDate() {
        dateFormatter.formattedDate = "custom_date"
        let list = TodoList(todos: [makeTodo(id: "1", title: "T", date: Date())], total: 1, limit: 10)
        var capturedItems: [TodoDisplayItem]?
        viewMock.update_list_items_closure = { capturedItems = $0 }

        sut.didGetTodoList(list)

        XCTAssertEqual(capturedItems?.first?.date, "custom_date")
    }

    func test_toggleCompletion_callsInteractorUpdateTodo() {
        let list = TodoList(todos: [makeTodo(id: "1", title: "T", date: Date())], total: 1, limit: 10)
        var capturedItems: [TodoDisplayItem]?
        viewMock.update_list_items_closure = { capturedItems = $0 }
        sut.didGetTodoList(list)

        capturedItems?.first?.toggleCompletion()

        XCTAssertEqual(interactorMock.update_todo_todo_calls_count, 1)
    }

    // MARK: - didChangeSearch

    func test_didChangeSearch_withEmptyQuery_updatesListWithAllItems() {
        let list = TodoList(
            todos: [
                makeTodo(id: "1", title: "Apple", date: Date()),
                makeTodo(id: "2", title: "Banana", date: Date())
            ],
            total: 2,
            limit: 10
        )
        sut.didGetTodoList(list)
        var capturedItems: [TodoDisplayItem]?
        viewMock.updateListClosure = { capturedItems = $0 }

        sut.didChangeSearch(query: nil)

        XCTAssertEqual(capturedItems?.count, 2)
    }

    func test_didChangeSearch_withQuery_filtersByTitleAndDescription() {
        let list = TodoList(
            todos: [
                makeTodo(id: "1", title: "Apple", date: Date()),
                makeTodo(id: "2", title: "Banana", date: Date()),
                makeTodo(id: "3", title: "Orange", date: Date(), isCompleted: false, description: "Apple juice")
            ],
            total: 3,
            limit: 10
        )
        sut.didGetTodoList(list)
        var capturedItems: [TodoDisplayItem]?
        viewMock.updateListClosure = { capturedItems = $0 }

        sut.didChangeSearch(query: "apple")

        XCTAssertEqual(capturedItems?.count, 2)
        XCTAssertTrue(capturedItems?.contains { $0.title == "Apple" } ?? false)
        XCTAssertTrue(capturedItems?.contains { $0.title == "Orange" } ?? false)
    }

    // MARK: - Helpers

    private func makeTodo(id: String, title: String, date: Date, isCompleted: Bool = false, description: String = "") -> Todo {
        Todo(id: id, title: title, description: description, date: date, isCompleted: isCompleted)
    }
}
