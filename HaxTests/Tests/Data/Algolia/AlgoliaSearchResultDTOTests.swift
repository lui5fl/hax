//
//  AlgoliaSearchResultDTOTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 28/8/24.
//

import XCTest
@testable import Hax

final class AlgoliaSearchResultDTOTests: XCTestCase {

    // MARK: Tests

    func testInitFromDecoder_givenNoNilPropertiesJSON() throws {
        // Given
        let jsonResourceName = "AlgoliaSearchResultDTO_NoNilProperties"

        // When
        let sut = try algoliaSearchResultDTO(
            jsonResourceName: jsonResourceName
        )

        // Then
        XCTAssertEqual(sut.author, "pg")
        XCTAssertEqual(sut.children?.count, 4)
        XCTAssertEqual(sut.createdAt, "2006-10-09T18:21:51Z")
        XCTAssertEqual(sut.createdAtI, 1160418111)
        XCTAssertEqual(sut.numComments, 15)
        XCTAssertEqual(sut.objectID, "1")
        XCTAssertEqual(sut.points, 57)
        XCTAssertEqual(sut.storyId, 1)
        XCTAssertEqual(sut.title, "Y Combinator")
        XCTAssertEqual(sut.updatedAt, "2024-07-31T18:34:19Z")
        XCTAssertEqual(sut.url, "http://ycombinator.com")
    }

    func testInitFromDecoder_givenSomeNilPropertiesJSON() throws {
        // Given
        let jsonResourceName = "AlgoliaSearchResultDTO_SomeNilProperties"

        // When
        let sut = try algoliaSearchResultDTO(
            jsonResourceName: jsonResourceName
        )

        // Then
        XCTAssertNil(sut.author)
        XCTAssertNil(sut.children)
        XCTAssertEqual(sut.createdAt, "2006-10-09T18:21:51Z")
        XCTAssertEqual(sut.createdAtI, 1160418111)
        XCTAssertNil(sut.numComments)
        XCTAssertEqual(sut.objectID, "1")
        XCTAssertNil(sut.points)
        XCTAssertNil(sut.storyId)
        XCTAssertNil(sut.title)
        XCTAssertEqual(sut.updatedAt, "2024-07-31T18:34:19Z")
        XCTAssertNil(sut.url)
    }
}
