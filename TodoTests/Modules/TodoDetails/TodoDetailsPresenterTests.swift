//
//  TodoDetailsPresenterTests.swift
//  TodoTests
//

import XCTest
import UIKit
import AppUIKit
@testable import Todo


private final class MockTodoDetailsDateFormatter: IDateFormatter {
    var formattedDate: String = "formatted_date"
    func todoDateString(from date: Date) -> String { formattedDate }
}

// MARK: - TodoDetailsPresenterTests

final class TodoDetailsPresenterTests: XCTestCase {

    private var interactorMock: ITodoDetailsInteractorInputMock!
    private var viewMock: ITodoDetailsViewMock!
    private var routerMock: ITodoDetailsRouterMock!
    private var dateFormatter: MockTodoDetailsDateFormatter!
    private var moduleOutputMock: TodoDetailsModuleOutputMock!
    private var sut: TodoDetailsPresenter!

    override func setUpWithError() throws {
        try super.setUpWithError()
        interactorMock = ITodoDetailsInteractorInputMock()
        viewMock = ITodoDetailsViewMock()
        routerMock = ITodoDetailsRouterMock()
        dateFormatter = MockTodoDetailsDateFormatter()
        moduleOutputMock = TodoDetailsModuleOutputMock()
    }

    override func tearDownWithError() throws {
        interactorMock = nil
        viewMock = nil
        routerMock = nil
        dateFormatter = nil
        moduleOutputMock = nil
        sut = nil
        try super.tearDownWithError()
    }

    // MARK: - viewDidLoad (with todoId)

    func test_viewDidLoad_withTodoId_callsInteractorFetchTodo() {
        sut = makePresenter(todoId: "id-1")
        sut.view = viewMock
        var capturedId: String?
        interactorMock.fetchTodo_idClosure = { capturedId = $0 }

        sut.viewDidLoad()

        XCTAssertEqual(interactorMock.fetchTodo_idCallsCount, 1)
        XCTAssertEqual(capturedId, "id-1")
    }

    func test_viewDidLoad_withTodoId_doesNotUpdateViewImmediately() {
        sut = makePresenter(todoId: "id-1")
        sut.view = viewMock

        sut.viewDidLoad()

        XCTAssertEqual(viewMock.update_itemCallsCount, 0)
    }

    // MARK: - viewDidLoad (without todoId – new todo)

    func test_viewDidLoad_withoutTodoId_doesNotCallInteractorFetchTodo() {
        sut = makePresenter(todoId: nil)
        sut.view = viewMock

        sut.viewDidLoad()

        XCTAssertEqual(interactorMock.fetchTodo_idCallsCount, 0)
    }

    func test_viewDidLoad_withoutTodoId_updatesViewWithEmptyItem() {
        sut = makePresenter(todoId: nil)
        sut.view = viewMock
        var capturedItem: TodoDetailsDisplayItem?
        viewMock.update_itemClosure = { capturedItem = $0 }

        sut.viewDidLoad()

        XCTAssertEqual(viewMock.update_itemCallsCount, 1)
        XCTAssertEqual(capturedItem?.title, "")
        XCTAssertEqual(capturedItem?.description, "")
        XCTAssertEqual(capturedItem?.date, "formatted_date")
    }

    // MARK: - didGetTodo

    func test_didGetTodo_callsViewUpdate() {
        sut = makePresenter(todoId: "1")
        sut.view = viewMock
        let todo = makeTodo(id: "1", title: "T", description: "D", date: Date())

        sut.didGetTodo(todo)

        XCTAssertEqual(viewMock.update_itemCallsCount, 1)
    }

    func test_didGetTodo_passesDisplayItemWithDateFromFormatter() {
        dateFormatter.formattedDate = "custom_date"
        sut = makePresenter(todoId: "1")
        sut.view = viewMock
        let todo = makeTodo(id: "1", title: "Title", description: "Desc", date: Date())
        var capturedItem: TodoDetailsDisplayItem?
        viewMock.update_itemClosure = { capturedItem = $0 }

        sut.didGetTodo(todo)

        XCTAssertEqual(capturedItem?.title, "Title")
        XCTAssertEqual(capturedItem?.description, "Desc")
        XCTAssertEqual(capturedItem?.date, "custom_date")
    }

    // MARK: - didTapSave

    func test_didTapSave_withoutTodo_doesNotCallInteractor() {
        sut = makePresenter(todoId: "1")
        sut.view = viewMock
        sut.viewDidLoad()
        interactorMock.saveTodo_todoCallsCount = 0

        sut.didTapSave()

        XCTAssertEqual(interactorMock.saveTodo_todoCallsCount, 0)
    }

    func test_didTapSave_withTodo_callsInteractorSaveTodo() {
        sut = makePresenter(todoId: "1")
        sut.view = viewMock
        sut.didGetTodo(makeTodo(id: "1", title: "A", description: "B", date: Date()))

        sut.didTapSave()

        XCTAssertEqual(interactorMock.saveTodo_todoCallsCount, 1)
    }

    func test_didTapSave_usesCurrentTitleAndDescription() {
        sut = makePresenter(todoId: "1")
        sut.view = viewMock
        sut.didGetTodo(makeTodo(id: "1", title: "Old", description: "OldDesc", date: Date()))
        sut.didChangeTitle("NewTitle")
        sut.didChangeDescription("NewDesc")
        var capturedTodo: Todo?
        interactorMock.saveTodo_todoClosure = { capturedTodo = $0 }

        sut.didTapSave()

        XCTAssertEqual(capturedTodo?.id, "1")
        XCTAssertEqual(capturedTodo?.title, "NewTitle")
        XCTAssertEqual(capturedTodo?.description, "NewDesc")
    }

    // MARK: - didSaveTodo

    func test_didSaveTodo_callsModuleOutputTodoDetailsDidFinish() {
        sut = makePresenter(todoId: "1")
        sut.moduleOutput = moduleOutputMock

        sut.didSaveTodo()

        XCTAssertEqual(moduleOutputMock.todoDetailsDidFinishCallsCount, 1)
    }

    // MARK: - didGetError

    func test_didGetError_callsRouterShowAlertWithMessage() {
        sut = makePresenter(todoId: nil)
        sut.view = viewMock
        let error = NSError(domain: "test", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error message"])
        var capturedMessage: String?
        routerMock.showAlert_messageClosure = { capturedMessage = $0 }

        sut.didGetError(error)

        XCTAssertEqual(routerMock.showAlert_messageCallsCount, 1)
        XCTAssertEqual(capturedMessage, "Error message")
    }

    // MARK: - Helpers

    private func makePresenter(todoId: String?) -> TodoDetailsPresenter {
        TodoDetailsPresenter(
            todoId: todoId,
            interactor: interactorMock,
            router: routerMock,
            dateFormatter: dateFormatter
        )
    }

    private func makeTodo(id: String = "id", title: String = "T", description: String = "D", date: Date = Date()) -> Todo {
        Todo(id: id, title: title, description: description, date: date, isCompleted: false)
    }
}
