//
//  NetworkClientTests.swift
//
//
//  Created by Luis Fariña on 9/5/24.
//

import Networking
import XCTest

final class NetworkClientTests: XCTestCase {

    // MARK: Properties

    private var sut: NetworkClient<APIMock>!
    private var urlSessionMock: URLSessionMock!
    private var jsonDecoderMock: JSONDecoderMock!

    // MARK: Set up and tear down

    override func setUp() {
        super.setUp()

        let apiMock = APIMock(scheme: "https", host: "luisfl.me")
        urlSessionMock = URLSessionMock()
        jsonDecoderMock = JSONDecoderMock()
        sut = NetworkClient(
            api: apiMock,
            urlSession: urlSessionMock,
            jsonDecoder: jsonDecoderMock
        )
    }

    override func tearDown() {
        sut = nil

        super.tearDown()
    }

    // MARK: Tests

    func testPerform() async throws {
        // Given
        urlSessionMock.dataStub = { _, _ in
            (Data("42".utf8), URLResponse())
        }
        let request = Request<APIMock>.get(EndpointMock(path: "/"))

        // When
        let performResult: Int = try await sut.perform(request)

        // Then
        XCTAssertEqual(performResult, 42)
        XCTAssertEqual(urlSessionMock.dataCallCount, 1)
        XCTAssertEqual(jsonDecoderMock.decodeCallCount, 1)
    }
}
