//
//  TodoDateFormatter.swift
//  Todo
//
//  Created by Aleksandr Lis on 15.02.2026.
//

import Foundation

public protocol IDateFormatter {
    func todoDateString(from date: Date) -> String
}

public final class TodoDateFormatter: IDateFormatter {

    public init() {}

    public func todoDateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: date)
    }
}
