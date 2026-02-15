//
//  TodoDateFormatter.swift
//  Todo
//
//  Created by Aleksandr Lis on 15.02.2026.
//

import Foundation

protocol IDateFormatter {
    func todoDateString(from date: Date) -> String
}

final class TodoDateFormatter: IDateFormatter {
    func todoDateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MMyy"
        return formatter.string(from: date)
    }
}
