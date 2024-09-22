//
//  URLSessionProtocol.swift
//
//
//  Created by Luis Fariña on 17/5/24.
//

import Foundation

public protocol URLSessionProtocol: Sendable {

    // MARK: Methods

    func data(
        for request: URLRequest,
        delegate: (any URLSessionTaskDelegate)?
    ) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
