//
//  URLSessionHTTPClient.swift
//  Network
//
//  Created by Aleksandr Lis on 15.02.2026.
//

import Foundation

public protocol HTTPClient: Sendable {
    func perform(_ request: URLRequest) async throws -> (Data, URLResponse)
}

public final class URLSessionHTTPClient: HTTPClient, @unchecked Sendable {
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func perform(_ request: URLRequest) async throws -> (Data, URLResponse) {
        try await session.data(for: request)
    }
}
