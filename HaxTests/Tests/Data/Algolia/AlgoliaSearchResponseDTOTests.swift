//
//  AlgoliaSearchResponseDTOTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 28/8/24.
//

import XCTest
@testable import Hax

final class AlgoliaSearchResponseDTOTests: XCTestCase {

    // MARK: Tests

    func testInitFromDecoder() throws {
        // Given
        let jsonResourceName = "AlgoliaSearchResponseDTO"

        // When
        let sut = try algoliaSearchResponseDTO(
            jsonResourceName: jsonResourceName
        )

        // Then
        XCTAssertEqual(sut.hits.count, 20)
    }
}
