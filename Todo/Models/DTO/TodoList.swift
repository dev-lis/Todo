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
}
