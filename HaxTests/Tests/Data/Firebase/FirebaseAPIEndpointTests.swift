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
}
