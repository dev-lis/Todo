//
//  ISO8601DateValue.swift
//  Todo
//
//  Created by Aleksandr Lis on 15.02.2026.
//

import Foundation

@propertyWrapper
struct ISO8601DateValue: Decodable {
    var wrappedValue: Date

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]

        guard let date = formatter.date(from: raw) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid ISO8601 date string: \(raw)"
            )
        }

        self.wrappedValue = date
    }
}
