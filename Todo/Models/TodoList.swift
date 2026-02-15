//
//  TodoList.swift
//  Todo
//
//  Created by Aleksandr Lis on 15.02.2026.
//

import Foundation

struct Todo: Decodable {
    let id: Int
    let title: String
    let description: String
    @ISO8601DateValue
    var date: Date
    var isCompleted: Bool
}

struct TodoList: Decodable {
    let todos: [Todo]
    let total: Int
    let limit: Int
}
