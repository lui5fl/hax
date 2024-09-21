//
//  RequestTests.swift
//
//
//  Created by Luis Fariña on 9/5/24.
//

import Foundation
import Testing
@testable import Networking

struct RequestTests {

    // MARK: Tests

    @Test func urlRequest_givenHTTPMethodIsGETAndURLIsNotValid() {
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
        #expect(
            throws: Request<APIMock>.Error.invalidURL,
            performing: urlRequest
        )
    }

    @Test func urlRequest_givenHTTPMethodIsGETAndURLIsValid() throws {
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
        #expect(
            urlRequest.url ==
            URL(string: "https://luisfl.me/?name=value")
        )
        #expect(urlRequest.httpMethod == "GET")
    }
}
