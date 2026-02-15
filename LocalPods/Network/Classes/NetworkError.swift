//
//  NetworkError.swift
//  Network
//
//  Created by Aleksandr Lis on 15.02.2026.
//

import Foundation

public enum NetworkError: Error, Sendable {
    case invalidURL
    case noData
    case httpError(statusCode: Int, data: Data?)
    case decodingError(Error)
    case connectionError(Error)
}
