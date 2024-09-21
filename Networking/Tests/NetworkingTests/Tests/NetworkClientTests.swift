//
//  NetworkClientTests.swift
//
//
//  Created by Luis Fariña on 9/5/24.
//

import Foundation
import Networking
import Testing

struct NetworkClientTests {

    // MARK: Properties

    private let sut: NetworkClient<APIMock>
    private let urlSessionMock: URLSessionMock
    private let jsonDecoderMock: JSONDecoderMock

    // MARK: Initialization

    init() {
        let apiMock = APIMock(scheme: "https", host: "luisfl.me")
        urlSessionMock = URLSessionMock()
        jsonDecoderMock = JSONDecoderMock()
        sut = NetworkClient(
            api: apiMock,
            urlSession: urlSessionMock,
            jsonDecoder: jsonDecoderMock
        )
    }

    // MARK: Tests

    @Test func perform() async throws {
        // Given
        await urlSessionMock.dataStub { _, _ in
            (Data("42".utf8), URLResponse())
        }
        let request = Request<APIMock>.get(EndpointMock(path: "/"))

        // When
        let performResult: Int = try await sut.perform(request)

        // Then
        #expect(performResult == 42)
        #expect(await urlSessionMock.dataCallCount == 1)
        #expect(jsonDecoderMock.decodeCallCount == 1)
    }
}
