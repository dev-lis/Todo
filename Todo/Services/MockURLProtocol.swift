//
//  MockURLProtocol.swift
//  Todo
//
//  Created by Aleksandr Lis on 15.02.2026.
//

import Foundation

final class MockURLProtocol: URLProtocol {
    static var mockedURL: URL?
    static var mockedStatusCode: Int = 200
    static var mockedHeaders: [String: String] = ["Content-Type": "application/json"]
    static var mockedData: Data?
    static var mockedError: Error?

    override class func canInit(with request: URLRequest) -> Bool {
        guard let target = mockedURL, let url = request.url else { return false }
        return url == target
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        if let error = Self.mockedError {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }

        guard let url = request.url else {
            client?.urlProtocol(self, didFailWithError: URLError(.badURL))
            return
        }

        let response = HTTPURLResponse(
            url: url,
            statusCode: Self.mockedStatusCode,
            httpVersion: "HTTP/1.1",
            headerFields: Self.mockedHeaders
        )!

        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)

        if let data = Self.mockedData {
            client?.urlProtocol(self, didLoad: data)
        }

        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
