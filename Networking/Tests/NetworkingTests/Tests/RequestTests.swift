//
//  RequestTests.swift
//
//
//  Created by Luis Fariña on 9/5/24.
//

import XCTest
@testable import Networking

final class RequestTests: XCTestCase {

    // MARK: Tests

    func testURLRequest_givenHTTPMethodIsGETAndURLIsNotValid() {
        // Given
        let api = APIMock(scheme: "https", host: "/")
        let sut = Request<APIMock>.get(
            EndpointMock(
                path: "/",
                queryItems: [
                    URLQueryItem(name: "name", value: "value")
                ]
            )
        )

        // When
        let urlRequest = {
            try sut.urlRequest(api: api)
        }

        // Then
        try XCTAssertThrowsError(urlRequest()) { error in
            XCTAssertEqual(
                error as? Request<APIMock>.Error,
                .invalidURL
            )
        }
    }

    func testURLRequest_givenHTTPMethodIsGETAndURLIsValid() throws {
        // Given
        let api = APIMock(scheme: "https", host: "luisfl.me")
        let sut = Request<APIMock>.get(
            EndpointMock(
                path: "/",
                queryItems: [
                    URLQueryItem(name: "name", value: "value")
                ]
            )
        )

        // When
        let urlRequest = try sut.urlRequest(api: api)

        // Then
        XCTAssertEqual(
            urlRequest.url,
            URL(string: "https://luisfl.me/?name=value")
        )
        XCTAssertEqual(urlRequest.httpMethod, "GET")
    }
}
