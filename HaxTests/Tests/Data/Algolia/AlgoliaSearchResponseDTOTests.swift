//
//  AlgoliaSearchResponseDTOTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 28/8/24.
//

import Testing
@testable import Hax

struct AlgoliaSearchResponseDTOTests {

    // MARK: Tests

    @Test func initializeFromDecoder() throws {
        // Given
        let jsonResourceName = "AlgoliaSearchResponseDTO"

        // When
        let sut = try JSONHelper.algoliaSearchResponseDTO(
            jsonResourceName: jsonResourceName
        )

        // Then
        #expect(sut.hits.count == 20)
    }
}
