//
//  URLSessionDebug.swift
//  Hax
//
//  Created by Luis Fariña on 11/2/25.
//

#if DEBUG

import Foundation
import Networking

final class URLSessionDebug: URLSessionProtocol {

    // MARK: Properties

    private let urlSession = URLSession(configuration: .default)

    // MARK: Methods

    func data(
        for request: URLRequest,
        delegate: (any URLSessionTaskDelegate)?
    ) async throws -> (Data, URLResponse) {
        let (data, response) = try await urlSession.data(
            for: request,
            delegate: delegate
        )
        Task {
            await LoggedRequests.shared.add(
                LoggedRequests.Request(
                    request: request,
                    response: response,
                    data: data
                )
            )
        }

        return (data, response)
    }
}

#endif
