//
//  NetworkClient.swift
//
//
//  Created by Luis Fariña on 10/5/24.
//

import Foundation

public protocol NetworkClientProtocol {

    // MARK: Types

    associatedtype API: APIProtocol

    // MARK: Methods

    /// Performs a network request and decodes the response into the specified type.
    ///
    /// - Parameters:
    ///   - request: The request to be performed
    func perform<T: Decodable>(_ request: Request<API>) async throws -> T
}

public struct NetworkClient<API: APIProtocol>: NetworkClientProtocol {

    // MARK: Properties

    private let api: API
    private let urlSession: URLSessionProtocol
    private let jsonDecoder: JSONDecoder

    // MARK: Initialization

    public init(
        api: API,
        urlSession: URLSessionProtocol = URLSession.shared,
        jsonDecoder: JSONDecoder = JSONDecoder()
    ) {
        self.api = api
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }

    // MARK: Methods

    public func perform<T: Decodable>(_ request: Request<API>) async throws -> T {
        try await jsonDecoder.decode(
            T.self,
            from: urlSession.data(
                for: request.urlRequest(api: api),
                delegate: nil
            ).0
        )
    }
}
