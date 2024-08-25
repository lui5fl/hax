//
//  AlgoliaAPIEndpointTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 12/5/24.
//

import XCTest
@testable import Hax

final class AlgoliaAPIEndpointTests: XCTestCase {

    // MARK: Tests

    func testPath_givenItemEndpoint() {
        // Given
        let id = 42
        let sut = AlgoliaAPI.Endpoint.item(id: id)

        // When
        let path = sut.path

        // Then
        XCTAssertEqual(path, "/api/v1/items/\(id)")
    }

    func testPath_givenSearchEndpoint() {
        // Given
        let sut = AlgoliaAPI.Endpoint.search(query: "query")

        // When
        let path = sut.path

        // Then
        XCTAssertEqual(path, "/api/v1/search")
    }

    func testQueryItems_givenItemEndpoint() {
        // Given
        let sut = AlgoliaAPI.Endpoint.item(id: 42)

        // When
        let queryItems = sut.queryItems

        // Then
        XCTAssertNil(queryItems)
    }

    func testQueryItems_givenSearchEndpoint() {
        // Given
        let query = "query"
        let sut = AlgoliaAPI.Endpoint.search(query: query)

        // When
        let queryItems = sut.queryItems

        // Then
        XCTAssertEqual(
            queryItems,
            [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "tags", value: "story")
            ]
        )
    }
}
