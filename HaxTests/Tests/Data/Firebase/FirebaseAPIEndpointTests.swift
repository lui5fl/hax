//
//  FirebaseAPIEndpointTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 12/5/24.
//

import Testing
@testable import Hax

struct FirebaseAPIEndpointTests {

    // MARK: Tests

    @Test func path_givenFeedEndpoint() {
        // Given
        let resource = "topstories"
        let sut = FirebaseAPI.Endpoint.feed(resource: resource)

        // When
        let path = sut.path

        // Then
        #expect(path == "/v0/\(resource).json")
    }

    @Test func path_givenItemEndpoint() {
        // Given
        let id = 42
        let sut = FirebaseAPI.Endpoint.item(id: id)

        // When
        let path = sut.path

        // Then
        #expect(path == "/v0/item/\(id).json")
    }

    @Test func path_givenMaxitemEndpoint() {
        // Given
        let sut = FirebaseAPI.Endpoint.maxitem

        // When
        let path = sut.path

        // Then
        #expect(path == "/v0/maxitem.json")
    }

    @Test func path_givenUserEndpoint() {
        // Given
        let id = "pg"
        let sut = FirebaseAPI.Endpoint.user(id: id)

        // When
        let path = sut.path

        // Then
        #expect(path == "/v0/user/\(id).json")
    }

    @Test func queryItems_givenFeedEndpoint() {
        // Given
        let sut = FirebaseAPI.Endpoint.feed(resource: "topstories")

        // When
        let queryItems = sut.queryItems

        // Then
        #expect(queryItems == nil)
    }

    @Test func queryItems_givenItemEndpoint() {
        // Given
        let sut = FirebaseAPI.Endpoint.item(id: 42)

        // When
        let queryItems = sut.queryItems

        // Then
        #expect(queryItems == nil)
    }

    @Test func queryItems_givenMaxitemEndpoint() {
        // Given
        let sut = FirebaseAPI.Endpoint.maxitem

        // When
        let queryItems = sut.queryItems

        // Then
        #expect(queryItems == nil)
    }

    @Test func queryItems_givenUserEndpoint() {
        // Given
        let sut = FirebaseAPI.Endpoint.user(id: "pg")

        // When
        let queryItems = sut.queryItems

        // Then
        #expect(queryItems == nil)
    }
}
