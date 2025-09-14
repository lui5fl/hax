//
//  URLSessionMock.swift
//
//
//  Created by Luis Fariña on 17/5/24.
//

import Foundation
import Networking
import Testing

actor URLSessionMock: URLSessionProtocol {

    // MARK: Types

    typealias DataStub = @Sendable (
        _ request: URLRequest,
        _ delegate: (any URLSessionTaskDelegate)?
    ) async throws -> (Data, URLResponse)

    // MARK: Properties

    private(set) var dataCallCount = Int.zero
    private var _dataStub: DataStub?

    // MARK: Methods

    func data(
        for request: URLRequest,
        delegate: (any URLSessionTaskDelegate)?
    ) async throws -> (Data, URLResponse) {
        dataCallCount += 1
        let _dataStub = try #require(_dataStub)

        return try await _dataStub(request, delegate)
    }

    func dataStub(_ dataStub: DataStub?) {
        _dataStub = dataStub
    }
}
