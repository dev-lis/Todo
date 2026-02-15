//
//  INetworkService.swift
//  Network
//
//  Created by Aleksandr Lis on 15.02.2026.
//

import Foundation

public protocol INetworkService {
    func request<T: Decodable>(_ request: URLRequest, completion: @escaping (Result<T, Error>) -> Void)
}
