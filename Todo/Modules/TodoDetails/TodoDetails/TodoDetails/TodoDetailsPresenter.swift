//  
//  TodoDetailsPresenter.swift
//  Todo
//
//  Created by Aleksandr Lis on 18.02.2026.
//
//

import AppUIKit

protocol ITodoDetailsPresenter {
    func viewDidLoad()
    func didTapSave()
    func didChangeTitle(_ title: String)
    func didChangeDescription(_ description: String)
}

protocol TodoDetailsModuleOutput: AnyObject {
    func todoDetailsDidFinish()
}

final class TodoDetailsPresenter {

    private var todo: Todo?
    private var currentTitle: String = ""
    private var currentDescription: String = ""

    weak var view: ITodoDetailsView?

    weak var moduleOutput: TodoDetailsModuleOutput?

    private let todoId: String?
    private let interactor: ITodoDetailsInteractorInput
    private let router: ITodoDetailsRouter
    private let dateFormatter: IDateFormatter

    init(todoId: String?,
         interactor: ITodoDetailsInteractorInput,
         router: ITodoDetailsRouter,
         dateFormatter: IDateFormatter) {
        self.todoId = todoId
        self.interactor = interactor
        self.router = router
        self.dateFormatter = dateFormatter
    }
}

// MARK: - ITodoDetailsPresenter

extension TodoDetailsPresenter: ITodoDetailsPresenter {
    func viewDidLoad() {
        if let todoId {
            interactor.fetchTodo(by: todoId)
        } else {
            let todo = Todo(
                id: UUID().uuidString,
                title: "",
                description: "",
                date: Date(),
                isCompleted: false
            )
            didGetTodo(todo)
            self.todo = todo
        }
    }

    func didTapSave() {
        guard let todo else { return }
        let title = currentTitle.normalized
        let description = currentDescription.normalized
        let updatedTodo = Todo(
            id: todo.id,
            title: title.isEmpty ? todo.title : title,
            description: description.isEmpty ? todo.description : description,
            date: Date(),
            isCompleted: false
        )
        interactor.saveTodo(updatedTodo)
    }

    func didChangeTitle(_ title: String) {
        currentTitle = title
    }

    func didChangeDescription(_ description: String) {
        currentDescription = description
    }
}

// MARK: - ITodoDetailsInteractorOutput

extension TodoDetailsPresenter: ITodoDetailsInteractorOutput {
    func didGetTodo(_ todo: Todo) {
        self.todo = todo
        currentTitle = todo.title
        currentDescription = todo.description
        let item = TodoDetailsDisplayItem(
            title: todo.title,
            date: dateFormatter.todoDateString(from: todo.date),
            description: todo.description
        )
        view?.update(item: item)
    }

    func didSaveTodo() {
        moduleOutput?.todoDetailsDidFinish()
    }

    func didGetError(_ error: Error) {
        // TODO: handle error router
    }
}
