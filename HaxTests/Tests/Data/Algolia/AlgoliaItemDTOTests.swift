//
//  AlgoliaItemDTOTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 11/5/24.
//

import XCTest
@testable import Hax

final class AlgoliaItemDTOTests: XCTestCase {

    // MARK: Tests

    func testInitFromDecoder_givenNoNilPropertiesJSON() throws {
        // Given
        let jsonResourceName = "AlgoliaItemDTO_NoNilProperties"

        // When
        let sut = try algoliaItemDTO(jsonResourceName: jsonResourceName)

        // Then
        XCTAssertEqual(sut.author, "pg")
        XCTAssertEqual(sut.children.count, 1)
        XCTAssertEqual(sut.createdAt, "2006-10-09T18:21:51.000Z")
        XCTAssertEqual(sut.createdAtI, 1160418111)
        XCTAssertEqual(sut.id, 1)
        XCTAssertEqual(sut.options.count, 1)
        XCTAssertEqual(sut.parentId, 42)
        XCTAssertEqual(sut.points, 57)
        XCTAssertEqual(sut.storyId, 1)
        XCTAssertEqual(sut.text, "text")
        XCTAssertEqual(sut.title, "Y Combinator")
        XCTAssertEqual(sut.type, "story")
        XCTAssertEqual(sut.url, "http://ycombinator.com")
    }

    func testInitFromDecoder_givenSomeNilPropertiesJSON() throws {
        // Given
        let jsonResourceName = "AlgoliaItemDTO_SomeNilProperties"

        // When
        let sut = try algoliaItemDTO(jsonResourceName: jsonResourceName)

        // Then
        XCTAssertEqual(sut.author, "pg")
        XCTAssert(sut.children.isEmpty)
        XCTAssertEqual(sut.createdAt, "2006-10-09T18:21:51.000Z")
        XCTAssertEqual(sut.createdAtI, 1160418111)
        XCTAssertEqual(sut.id, 1)
        XCTAssert(sut.options.isEmpty)
        XCTAssertNil(sut.parentId)
        XCTAssertNil(sut.points)
        XCTAssertNil(sut.storyId)
        XCTAssertNil(sut.text)
        XCTAssertNil(sut.title)
        XCTAssertEqual(sut.type, "story")
        XCTAssertNil(sut.url)
    }
}
