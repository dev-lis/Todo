//
//  TodoItemDisplay.swift
//  Todo
//
//  Created by Aleksandr on 15.02.2026.
//

import Foundation

struct TodoItemDisplay: Hashable {
    let title: String
    let description: String?
    let date: String
    let isCompleted: Bool

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(description ?? "")
        hasher.combine(date)
        hasher.combine(isCompleted)
    }

    static func == (lhs: TodoItemDisplay, rhs: TodoItemDisplay) -> Bool {
        lhs.title == rhs.title
        && lhs.description == rhs.description
        && lhs.date == rhs.date
        && lhs.isCompleted == rhs.isCompleted
    }
}
