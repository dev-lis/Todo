//
//  JSONParser.swift
//  Todo
//
//  Created by Aleksandr Lis on 15.02.2026.
//

import Foundation

enum JSONError: Error {
    case fileNotFound(String)
    case unreadableFile(String)
}

final class JSONParser {
    static func data(
        from fileName: String,
        fileExtension: String = "json",
        bundle: Bundle = .main
    ) -> Data? {
        guard let url = bundle.url(forResource: fileName, withExtension: fileExtension) else {
            return nil
        }

        return try? Data(contentsOf: url)
    }
}
