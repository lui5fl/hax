//
//  URLSessionMock.swift
//
//
//  Created by Luis Fariña on 17/5/24.
//

import Foundation
import Networking
import Testing

final class URLSessionMock: URLSessionProtocol {

    // MARK: Properties

    var dataStub: ((
        _ request: URLRequest,
        _ delegate: (any URLSessionTaskDelegate)?
    ) async throws -> (Data, URLResponse))?

    private(set) var dataCallCount = Int.zero

    // MARK: Methods

    func data(
        for request: URLRequest,
        delegate: (any URLSessionTaskDelegate)?
    ) async throws -> (Data, URLResponse) {
        dataCallCount += 1

        return try await (#require(dataStub))(request, delegate)
    }
}
