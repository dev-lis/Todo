//
//  Localization.swift
//  Todo
//
//  Created by Aleksandr Lis on 16.02.2026.
//

import Foundation

public typealias L = Localization

public enum Localization {
    public static func string(_ key: String, table: String? = nil, bundle: Bundle = .main) -> String {
        NSLocalizedString(key, tableName: table, bundle: bundle, comment: "")
    }

    public static func plural(_ key: String, count: Int, table: String? = nil, bundle: Bundle = .main) -> String {
        let format = NSLocalizedString(key, tableName: table, bundle: bundle, comment: "")
        return NSString.localizedStringWithFormat(format as NSString, count) as String
    }

    public static func format(_ key: String, _ args: CVarArg..., table: String? = nil, bundle: Bundle = .main) -> String {
        let format = NSLocalizedString(key, tableName: table, bundle: bundle, comment: "")
        return String(format: format, arguments: args)
    }
}

