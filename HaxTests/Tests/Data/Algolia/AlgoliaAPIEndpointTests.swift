//
//  AlgoliaAPIEndpointTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 12/5/24.
//

import Foundation
import Testing
@testable import Hax

struct AlgoliaAPIEndpointTests {

    // MARK: Tests

    @Test func path_givenItemEndpoint() {
        // Given
        let id = 42
        let sut = AlgoliaAPI.Endpoint.item(id: id)

        // When
        let path = sut.path

        // Then
        #expect(path == "/api/v1/items/\(id)")
    }

    @Test func path_givenSearchEndpoint() {
        // Given
        let sut = AlgoliaAPI.Endpoint.search(query: "query")

        // When
        let path = sut.path

        // Then
        #expect(path == "/api/v1/search")
    }

    @Test func queryItems_givenItemEndpoint() {
        // Given
        let sut = AlgoliaAPI.Endpoint.item(id: 42)

        // When
        let queryItems = sut.queryItems

        // Then
        #expect(queryItems == nil)
    }

    @Test func queryItems_givenSearchEndpoint() {
        // Given
        let query = "query"
        let sut = AlgoliaAPI.Endpoint.search(query: query)

        // When
        let queryItems = sut.queryItems

        // Then
        #expect(
            queryItems ==
            [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "tags", value: "story")
            ]
        )
    }
}
