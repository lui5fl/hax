//
//  Request.swift
//
//
//  Created by Luis Fariña on 10/5/24.
//

import Foundation

public enum Request<API: APIProtocol> {

    // MARK: Types

    public enum Error: Swift.Error {

        // MARK: Cases

        case invalidURL
    }

    public typealias Endpoint = API.Endpoint

    // MARK: Cases

    case get(Endpoint)

    // MARK: Methods

    func urlRequest(api: API) throws -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = api.scheme
        urlComponents.host = api.host

        switch self {
        case .get(let endpoint):
            urlComponents.path = endpoint.path
        }

        guard let url = urlComponents.url else {
            throw Error.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod

        return urlRequest
    }
}

// MARK: - Private extension

private extension Request {

    // MARK: Properties

    var httpMethod: String {
        let httpMethod: String

        switch self {
        case .get:
            httpMethod = "GET"
        }

        return httpMethod
    }
}
