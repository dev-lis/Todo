//
//  Todo.swift
//  Todo
//
//  Created by Aleksandr Lis on 16.02.2026.
//

import AppUIKit

struct Todo: Decodable {
    let id: String
    var title: String
    var description: String
    @ISO8601DateValue
    var date: Date
    var isCompleted: Bool
}

#if STAGE
extension Todo {
    private enum StageCodingKeys: String, CodingKey {
        case id
        case title = "todo"
        case isCompleted = "completed"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StageCodingKeys.self)
        guard let int = try container.decodeIfPresent(Int.self, forKey: .id) else {
            throw DecodingError.typeMismatch(String.self, DecodingError.Context(codingPath: [], debugDescription: "Expected id"))
        }
        id = String(int)
        title = try container.decode(String.self, forKey: .title)
        description = ""
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        date = Date()
    }
}
#endif
