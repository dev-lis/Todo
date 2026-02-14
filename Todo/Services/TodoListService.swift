//
//  TodoListService.swift
//  Todo
//
//  Created by Aleksandr on 15.02.2026.
//

import Foundation

protocol ITodoListService {
    func fetchTodoList(completion: @escaping ([TodoList]) -> Void)
}

final class TodoListService: ITodoListService {
    func fetchTodoList(completion: @escaping ([TodoList]) -> Void) {
        let mocks = loadMockData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion(mocks)
        }
    }

    private func loadMockData() -> [TodoList] {
        [
            TodoList(
                id: 1,
                title: "Почитать книгу",
                description: "Составить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике.",
                date: Date(),
                isCompleted: true
            ),
            TodoList(
                id: 2,
                title: "Уборка в квартире",
                description: "Провести генеральную уборку в квартире",
                date: Date(),
                isCompleted: false
            ),
            TodoList(
                id: 3,
                title: "Заняться спортом",
                description: "Сходить в спортзал или сделать тренировку дома. Не забыть про разминку и растяжку!",
                date: Date(),
                isCompleted: false
            ),
            TodoList(
                id: 4,
                title: "Работа над проектом",
                description: "Выделить время для работы над проектом на работе. Сфокусироваться на выполнении важных задач",
                date: Date(),
                isCompleted: true
            ),
            TodoList(
                id: 5,
                title: "Вечерний отдых",
                description: "Найти время для расслабления перед сном: посмотреть фильм или послушать музыку",
                date: Date(),
                isCompleted: false
            ),
            TodoList(
                id: 6,
                title: "Зарядка утром",
                description: "",
                date: Date(),
                isCompleted: false
            ),
            TodoList(
                id: 7,
                title: "Испанский",
                description: "Провести 30 минут за изучением испанского языка с помощью приложения",
                date: Date(),
                isCompleted: false
            )
        ]
    }
}
