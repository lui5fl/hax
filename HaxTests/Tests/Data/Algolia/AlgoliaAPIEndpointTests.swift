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
}
