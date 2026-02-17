//
//  Todo.swift
//  Todo
//
//  Created by Aleksandr Lis on 16.02.2026.
//

import AppUIKit

struct Todo: Decodable {
    let id: Int
    let title: String
    let description: String
    @ISO8601DateValue
    var date: Date
    var isCompleted: Bool

    init(id: Int, title: String, description: String, date: Date, isCompleted: Bool) {
        self.id = id
        self.title = title
        self.description = description
        self.date = date
        self.isCompleted = isCompleted
    }
}

#if STAGE
extension Todo {
    private enum CodingKeys: String, CodingKey {
        case id
        case title = "todo"
        case isCompleted = "completed"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = ""
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        date = Date()
    }
}
#endif
