//
//  TodoDetailsPresenterTests.swift
//  TodoTests
//

import XCTest
import UIKit
import AppUIKit
@testable import Todo

// MARK: - Mock ITodoDetailsInteractorInput

private final class MockTodoDetailsInteractorInput: ITodoDetailsInteractorInput {
    var fetchTodo_byCallsCount = 0
    var fetchTodo_byArg: String?
    var fetchTodo_byClosure: ((String) -> Void)?

    func fetchTodo(by id: String) {
        fetchTodo_byCallsCount += 1
        fetchTodo_byArg = id
        fetchTodo_byClosure?(id)
    }

    var saveTodo_todoCallsCount = 0
    var saveTodo_todoArg: Todo?
    var saveTodo_todoClosure: ((Todo) -> Void)?

    func saveTodo(_ todo: Todo) {
        saveTodo_todoCallsCount += 1
        saveTodo_todoArg = todo
        saveTodo_todoClosure?(todo)
    }
}

// MARK: - Mock ITodoDetailsView

private final class MockTodoDetailsView: ITodoDetailsView {
    var update_itemCallsCount = 0
    var update_itemArg: TodoDetailsDisplayItem?
    var update_itemClosure: ((TodoDetailsDisplayItem) -> Void)?

    func update(item: TodoDetailsDisplayItem) {
        update_itemCallsCount += 1
        update_itemArg = item
        update_itemClosure?(item)
    }
}

// MARK: - Mock ITodoDetailsRouter

private final class MockTodoDetailsRouter: ITodoDetailsRouter {
    var viewController: UIViewController?

    var showAlertMessageCallsCount = 0
    var showAlertMessageArg: String?

    func showAlert(message: String) {
        showAlertMessageCallsCount += 1
        showAlertMessageArg = message
    }
}

// MARK: - Mock IDateFormatter

private final class MockTodoDetailsDateFormatter: IDateFormatter {
    var formattedDate: String = "formatted_date"
    func todoDateString(from date: Date) -> String { formattedDate }
}

// MARK: - Mock TodoDetailsModuleOutput

private final class MockTodoDetailsModuleOutput: TodoDetailsModuleOutput {
    var todoDetailsDidFinishCallsCount = 0
    func todoDetailsDidFinish() {
        todoDetailsDidFinishCallsCount += 1
    }
}

// MARK: - TodoDetailsPresenterTests

final class TodoDetailsPresenterTests: XCTestCase {

    private var interactorMock: MockTodoDetailsInteractorInput!
    private var viewMock: MockTodoDetailsView!
    private var routerMock: MockTodoDetailsRouter!
    private var dateFormatter: MockTodoDetailsDateFormatter!
    private var moduleOutputMock: MockTodoDetailsModuleOutput!
    private var sut: TodoDetailsPresenter!

    override func setUpWithError() throws {
        try super.setUpWithError()
        interactorMock = MockTodoDetailsInteractorInput()
        viewMock = MockTodoDetailsView()
        routerMock = MockTodoDetailsRouter()
        dateFormatter = MockTodoDetailsDateFormatter()
        moduleOutputMock = MockTodoDetailsModuleOutput()
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

        sut.viewDidLoad()

        XCTAssertEqual(interactorMock.fetchTodo_byCallsCount, 1)
        XCTAssertEqual(interactorMock.fetchTodo_byArg, "id-1")
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

        XCTAssertEqual(interactorMock.fetchTodo_byCallsCount, 0)
    }

    func test_viewDidLoad_withoutTodoId_updatesViewWithEmptyItem() {
        sut = makePresenter(todoId: nil)
        sut.view = viewMock

        sut.viewDidLoad()

        XCTAssertEqual(viewMock.update_itemCallsCount, 1)
        XCTAssertEqual(viewMock.update_itemArg?.title, "")
        XCTAssertEqual(viewMock.update_itemArg?.description, "")
        XCTAssertEqual(viewMock.update_itemArg?.date, "formatted_date")
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

        sut.didGetTodo(todo)

        XCTAssertEqual(viewMock.update_itemArg?.title, "Title")
        XCTAssertEqual(viewMock.update_itemArg?.description, "Desc")
        XCTAssertEqual(viewMock.update_itemArg?.date, "custom_date")
    }

    // MARK: - didTapSave

    func test_didTapSave_withoutTodo_doesNotCallInteractor() {
        sut = makePresenter(todoId: "1")
        sut.view = viewMock
        sut.viewDidLoad()
        // didGetTodo not called — todo still nil (e.g. fetch not completed)
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

        sut.didGetError(error)

        XCTAssertEqual(routerMock.showAlertMessageCallsCount, 1)
        XCTAssertEqual(routerMock.showAlertMessageArg, "Error message")
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
