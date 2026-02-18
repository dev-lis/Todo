//
//  TodoDisplayItem.swift
//  Todo
//
//  Created by Aleksandr Lis on 15.02.2026.
//

import Foundation

struct TodoDisplayItem: Hashable {
    private let id: String
    let title: String
    let description: String?
    let date: String
    var isCompleted: Bool

    var toggleCompletion: () -> Void

    init(id: String,
         title: String,
         description: String?,
         date: String,
         isCompleted: Bool,
         toggleCompletion: @escaping () -> Void) {
        self.id = id
        self.title = title
        self.description = description
        self.date = date
        self.isCompleted = isCompleted
        self.toggleCompletion = toggleCompletion
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(description ?? "")
        hasher.combine(date)
        hasher.combine(isCompleted)
    }

    static func == (lhs: TodoDisplayItem, rhs: TodoDisplayItem) -> Bool {
        lhs.id == rhs.id
        && lhs.title == rhs.title
        && lhs.description == rhs.description
        && lhs.date == rhs.date
        && lhs.isCompleted == rhs.isCompleted
    }
}
