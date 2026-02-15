//
//  JSONParser.swift
//  Todo
//
//  Created by Aleksandr Lis on 15.02.2026.
//

import Foundation

public final class JSONParser {
    public static func data(
        from fileName: String,
        bundle: Bundle = .main
    ) -> Data? {
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            return nil
        }

        return try? Data(contentsOf: url)
    }
}
