//
//  String+Extensions.swift
//  AppUIKit
//
//  Created by Aleksandr Lis on 16.02.2026.
//

import Foundation

public extension String {
    func localized(table: String? = nil, bundle: Bundle = .main) -> String {
        NSLocalizedString(self, tableName: table, bundle: bundle, comment: "")
    }

    func plural(count: Int, table: String? = nil, bundle: Bundle = .main) -> String {
        let format = NSLocalizedString(self, tableName: table, bundle: bundle, comment: "")
        return NSString.localizedStringWithFormat(format as NSString, count) as String
    }

    func format(args: CVarArg..., table: String? = nil, bundle: Bundle = .main) -> String {
        let format = NSLocalizedString(self, tableName: table, bundle: bundle, comment: "")
        return String(format: format, arguments: args)
    }

    var normalized: String {
        let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.replacingOccurrences(
            of: "\\s+",
            with: " ",
            options: .regularExpression
        )
    }
}
