//
//  TodoListViewControllerContextMenuTests.swift
//  TodoTests
//

import XCTest
import AppUIKit
@testable import Todo

final class TodoListViewControllerContextMenuTests: XCTestCase {

    func test_viewControllerWithItems_updateList_doesNotCrash() {
        let presenter = ITodoListPresenterMock()
        let vc = TodoListViewController(presenter: presenter)
        vc.loadViewIfNeeded()

        let item = TodoDisplayItem(
            id: "1",
            title: "Task",
            description: nil,
            date: "01.02.2026",
            isCompleted: false,
            toggleCompletion: {}
        )

        let exp = expectation(description: "updateList")
        (vc as ITodoListView).updateList(items: [item])
        DispatchQueue.main.async { exp.fulfill() }
        wait(for: [exp], timeout: 1)
    }

    func test_contextMenuConfigurationForRowAt_withItem_returnsConfiguration() throws {
        guard let (vc, tableView) = Self.getViewControllerWithTableView() else {
            throw XCTSkip("TableView not accessible for test")
        }
        let item = TodoDisplayItem(
            id: "1",
            title: "Task",
            description: "Desc",
            date: "01.02.2026",
            isCompleted: false,
            toggleCompletion: {}
        )
        let exp = expectation(description: "snapshot")
        (vc as ITodoListView).updateList(items: [item])
        DispatchQueue.main.async { exp.fulfill() }
        wait(for: [exp], timeout: 1)

        let config = vc.tableView(tableView, contextMenuConfigurationForRowAt: IndexPath(row: 0, section: 0), point: .zero)

        XCTAssertNotNil(config, "Context menu configuration should be returned when item exists")
    }

    func test_contextMenuConfigurationForRowAt_withoutItem_returnsNil() throws {
        guard let (vc, tableView) = Self.getViewControllerWithTableView() else {
            throw XCTSkip("TableView not accessible for test")
        }
        let exp = expectation(description: "empty list")
        (vc as ITodoListView).updateList(items: [])
        DispatchQueue.main.async { exp.fulfill() }
        wait(for: [exp], timeout: 1)

        let config = vc.tableView(tableView, contextMenuConfigurationForRowAt: IndexPath(row: 0, section: 0), point: .zero)

        XCTAssertNil(config, "Context menu configuration should be nil when no item at index path")
    }

    private static func getViewControllerWithTableView() -> (TodoListViewController, UITableView)? {
        let presenter = ITodoListPresenterMock()
        let vc = TodoListViewController(presenter: presenter)
        vc.loadViewIfNeeded()
        guard let tv = vc.value(forKey: "tableView") as? UITableView else { return nil }
        return (vc, tv)
    }
}
