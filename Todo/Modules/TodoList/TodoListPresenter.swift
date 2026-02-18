//  
//  TodoListPresenter.swift
//  Todo
//
//  Created by Aleksandr Lis on 15.02.2026.
//
//

import AppUIKit

// sourcery: AutoMockable
protocol ITodoListPresenter {
    func viewWillAppear()
    func didSelectTodo(at index: Int)
    func didTapAddButton()
    func didRequestDeleteTodo(at index: Int)
}

protocol TodoListModuleOutput: AnyObject {
    func openNewTodoDetail()
    func openTodoDetail(for id: String?)
}

final class TodoListPresenter {

    private var todos = [Todo]()

    weak var view: ITodoListView?

    weak var moduleOutput: TodoListModuleOutput?

    private let interactor: ITodoListInteractorInput
    private let router: ITodoListRouter
    private let dateFormatter: IDateFormatter

    init(interactor: ITodoListInteractorInput,
         router: ITodoListRouter,
         dateFormatter: IDateFormatter) {
        self.interactor = interactor
        self.router = router
        self.dateFormatter = dateFormatter
    }

    func handleTodoList(_ todoList: TodoList) {
        todos = todoList.todos.sorted { $0.date > $1.date }
        let items = todos.enumerated().map { index, todo in
            TodoDisplayItem(
                id: todo.id,
                title: todo.title,
                description: todo.description,
                date: dateFormatter.todoDateString(from: todo.date),
                isCompleted: todo.isCompleted) { [weak self, index] in
                    guard let self else { return }
                    self.todos[index].isCompleted.toggle()
                    self.interactor.updateTodo(self.todos[index])

                }
        }
        view?.updateList(items: items)
        view?.updateCounter(count: todoList.total)
    }
}

// MARK: - ITodoListPresenter

extension TodoListPresenter: ITodoListPresenter {
    func viewWillAppear() {
        interactor.fetchTodoList()
    }

    func didSelectTodo(at index: Int) {
        moduleOutput?.openTodoDetail(for: todos[index].id)
    }

    func didTapAddButton() {
        moduleOutput?.openNewTodoDetail()
    }

    func didRequestDeleteTodo(at index: Int) {
        guard index >= 0, index < todos.count else { return }
        interactor.deleteTodo(id: todos[index].id)
    }
}

// MARK: - ITodoListInteractorOutput

extension TodoListPresenter: ITodoListInteractorOutput {
    func didGetTodoList(_ list: TodoList) {
        handleTodoList(list)
    }

    func didGetError(_ error: Error) {
        // TODO: handle error router
    }
}
