//
//  LoggedRequests.swift
//  Hax
//
//  Created by Luis Fariña on 10/2/25.
//

#if DEBUG

import Foundation

@MainActor
@Observable
final class LoggedRequests {

    // MARK: Types

    struct Request: Identifiable {

        // MARK: Properties

        let id = UUID()
        let request: URLRequest
        let response: URLResponse
        let data: Data

        var statusCode: Int? {
            (response as? HTTPURLResponse)?.statusCode
        }

        var host: String? {
            request.url?.host()
        }

        var path: String? {
            request.url?.path()
        }

        var time: String {
            date.formatted(date: .omitted, time: .standard)
        }

        var responseBody: String? {
            String(bytes: data, encoding: .utf8)
        }

        private let date = Date()
    }

    // MARK: Properties

    static let shared = LoggedRequests()
    private(set) var requests: [Request] = []

    // MARK: Methods

    func add(_ request: Request) {
        requests.append(request)
    }

    func removeAll() {
        requests.removeAll()
    }
}

#endif
