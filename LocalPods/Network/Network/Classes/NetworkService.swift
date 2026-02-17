//
//  NetworkService.swift
//  Network
//
//  Created by Aleksandr Lis on 15.02.2026.
//

import Foundation

public final class NetworkService: Sendable {

    private let session: URLSession
    private let decoder: JSONDecoder

    public init(session: URLSession = .shared,
                decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
    }
}

// MARK: - INetworkService

extension NetworkService: INetworkService {
    public func request<T: Decodable>(_ request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        session.dataTask(with: request) { [weak self] data, response, error in
            guard let self else {
                completion(.failure(NetworkError.noData))
                return
            }
            do {
                try self.handle(data: data, response: response, error: error)
                let model: T = try self.decode(data)
                completion(.success(model))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

// MARK: - IConcurrencyNetworkService

extension NetworkService: IConcurrencyNetworkService {
    public func request<T: Decodable>( _ request: URLRequest) async throws -> T {
        let (data, response) = try await session.data(for: request)
        try handle(data: data, response: response)
        return try self.decode(data)
    }
}

private extension NetworkService {
    func handle(data: Data?, response: URLResponse?, error: Error? = nil) throws {
        if let error = error {
            throw error
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.noData
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode, data: data)
        }
    }

    func decode<T: Decodable>(_ data: Data?) throws -> T {
        do {
            guard let data else {
                throw NetworkError.noData
            }
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
