//
//  HTTPClient.swift
//  Network
//
//  Created by Aleksandr Lis on 15.02.2026.
//

import Foundation

public protocol HTTPClient: Sendable {
    func perform(_ request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
    func perform(_ request: URLRequest) async throws -> (Data, URLResponse)
}
