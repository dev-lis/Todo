//
//  NetworkService.swift
//  Network
//
//  Created by Aleksandr Lis on 15.02.2026.
//

import Foundation

public final class NetworkService: Sendable {
    private let client: HTTPClient
    private let decoder: JSONDecoder

    public init(client: HTTPClient = URLSessionHTTPClient(),
                decoder: JSONDecoder = .init()) {
        self.client = client
        self.decoder = decoder
    }
}

// MARK: - IConcurrencyNetworkService

extension NetworkService: IConcurrencyNetworkService {
    public func request<T: Decodable>( _ request: URLRequest) async throws -> T {
        let (data, response) = try await client.perform(request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.noData
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode, data: data)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
