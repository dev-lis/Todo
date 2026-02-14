//
//  TodoList.swift
//  Todo
//
//  Created by Aleksandr on 15.02.2026.
//

import Foundation

struct TodoList: Decodable {
    let id: Int
    let title: String
    let description: String
    let date: Date
    var isCompleted: Bool
}
