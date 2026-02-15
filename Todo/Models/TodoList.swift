//
//  TodoList.swift
//  Todo
//
//  Created by Aleksandr Lis on 15.02.2026.
//

import Foundation

struct TodoList: Decodable {
    let todos: [Todo]
    let total: Int
    let limit: Int
}
