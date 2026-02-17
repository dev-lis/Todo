//
//  TodoList.swift
//  Todo
//
//  Created by Aleksandr Lis on 15.02.2026.
//

import Foundation

struct TodoList: Decodable {
    var todos: [Todo]
    let total: Int
    let limit: Int

    init(todos: [Todo], total: Int, limit: Int) {
        self.todos = todos
        self.total = total
        self.limit = limit
    }
}
