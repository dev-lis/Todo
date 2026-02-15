//
//  IConcurrencyNetworkService.swift
//  Network
//
//  Created by Aleksandr Lis on 15.02.2026.
//

import Foundation

public protocol IConcurrencyNetworkService {
    func request<T: Decodable>(_ request: URLRequest) async throws -> T
}
