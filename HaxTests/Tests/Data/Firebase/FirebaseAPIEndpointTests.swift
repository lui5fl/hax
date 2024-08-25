//
//  FirebaseAPIEndpointTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 12/5/24.
//

import XCTest
@testable import Hax

final class FirebaseAPIEndpointTests: XCTestCase {

    // MARK: Tests

    func testPath_givenFeedEndpoint() {
        // Given
        let resource = "topstories"
        let sut = FirebaseAPI.Endpoint.feed(resource: resource)

        // When
        let path = sut.path

        // Then
        XCTAssertEqual(path, "/v0/\(resource).json")
    }

    func testPath_givenItemEndpoint() {
        // Given
        let id = 42
        let sut = FirebaseAPI.Endpoint.item(id: id)

        // When
        let path = sut.path

        // Then
        XCTAssertEqual(path, "/v0/item/\(id).json")
    }

    func testPath_givenUserEndpoint() {
        // Given
        let id = "pg"
        let sut = FirebaseAPI.Endpoint.user(id: id)

        // When
        let path = sut.path

        // Then
        XCTAssertEqual(path, "/v0/user/\(id).json")
    }

    func testQueryItems_givenFeedEndpoint() {
        // Given
        let sut = FirebaseAPI.Endpoint.feed(resource: "topstories")

        // When
        let queryItems = sut.queryItems

        // Then
        XCTAssertNil(queryItems)
    }

    func testQueryItems_givenItemEndpoint() {
        // Given
        let sut = FirebaseAPI.Endpoint.item(id: 42)

        // When
        let queryItems = sut.queryItems

        // Then
        XCTAssertNil(queryItems)
    }

    func testQueryItems_givenUserEndpoint() {
        // Given
        let sut = FirebaseAPI.Endpoint.user(id: "pg")

        // When
        let queryItems = sut.queryItems

        // Then
        XCTAssertNil(queryItems)
    }
}
