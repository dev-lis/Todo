//
//  TodoRequestBuilder.swift
//  Todo
//
//  Created by Aleksandr Lis on 15.02.2026.
//

import Network

// sourcery: AutoMockable
protocol ITodoRequestBuilder {
    func todoListdRequest() throws -> URLRequest
}

final class TodoRequestBuilder: ITodoRequestBuilder {
    func todoListdRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "dummyjson.com"
        components.path = "/todos"

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}
