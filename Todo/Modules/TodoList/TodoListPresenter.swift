//
//  TodoListPresenterPresenter.swift
//  Todo
//
//  
//  TodoListPresenter.swift
//  Todo
//
//  Created by Aleksandr on 15.02.2026.
//
//

import Foundation

protocol ITodoListPresenter {
    func viewDidLoad()
}

final class TodoListPresenter {

    weak var view: ITodoListView?

    private var interactor: ITodoListInteractorInput?
    private var router: ITodoListRouter?

    init(interactor: ITodoListInteractorInput,
         router: ITodoListRouter) {
        self.interactor = interactor
        self.router = router
    }

    private func loadMockData() {
        let tasks = [
            TodoItemDisplay(
                title: "Почитать книгу",
                description: "Составить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике.",
                date: "09/10/24",
                isCompleted: true
            ),
            TodoItemDisplay(
                title: "Уборка в квартире",
                description: "Провести генеральную уборку в квартире",
                date: "02/10/24",
                isCompleted: false
            ),
            TodoItemDisplay(
                title: "Заняться спортом",
                description: "Сходить в спортзал или сделать тренировку дома. Не забыть про разминку и растяжку!",
                date: "02/10/24",
                isCompleted: false
            ),
            TodoItemDisplay(
                title: "Работа над проектом",
                description: "Выделить время для работы над проектом на работе. Сфокусироваться на выполнении важных задач",
                date: "09/10/24",
                isCompleted: true
            ),
            TodoItemDisplay(
                title: "Вечерний отдых",
                description: "Найти время для расслабления перед сном: посмотреть фильм или послушать музыку",
                date: "02/10/24",
                isCompleted: false
            ),
            TodoItemDisplay(
                title: "Зарядка утром",
                description: "",
                date: "12/10/24",
                isCompleted: false
            ),
            TodoItemDisplay(
                title: "Испанский",
                description: "Провести 30 минут за изучением испанского языка с помощью приложения",
                date: "02/10/24",
                isCompleted: false
            )
        ]
        view?.update(items: tasks)
    }
}

// MARK: - ITodoListPresenter

extension TodoListPresenter: ITodoListPresenter {
    func viewDidLoad() {
        loadMockData()
    }
}

// MARK: - ITodoListInteractorOutput

extension TodoListPresenter: ITodoListInteractorOutput {}
