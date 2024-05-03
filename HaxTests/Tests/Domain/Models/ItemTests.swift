//
//  ItemTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 21/12/22.
//

import XCTest
@testable import Hax

final class ItemTests: XCTestCase {

    // MARK: Tests

    func testInit_givenAlgoliaItemDTO() throws {
        // Given
        let algoliaItemDTO = try algoliaItemDTO()

        // When
        let sut = Item(algoliaItemDTO: algoliaItemDTO)

        // Then
        XCTAssertEqual(sut.id, 1)
        XCTAssertFalse(sut.deleted)
        XCTAssertEqual(sut.kind, .story)
        XCTAssertEqual(sut.author, "pg")
        XCTAssertEqual(sut.body, "text")
        XCTAssertFalse(sut.dead)
        XCTAssertEqual(sut.children.count, 1)
        XCTAssertEqual(
            sut.url,
            URL(string: "http://ycombinator.com")
        )
        XCTAssertEqual(sut.score, 57)
        XCTAssertEqual(sut.title, "Y Combinator")
        XCTAssertNil(sut.descendants)
        XCTAssert(sut.comments.isEmpty)
        XCTAssertNotNil(sut.markdownBody)
        XCTAssertNotNil(sut.urlSimpleString)
        XCTAssertNotNil(sut.elapsedTimeString)
        XCTAssertEqual(
            sut.hackerNewsURL,
            URL(string: "https://news.ycombinator.com/item?id=1")
        )
    }

    func testInit_givenFirebaseItemDTO() throws {
        // Given
        let firebaseItemDTO = try firebaseItemDTO()

        // When
        let sut = Item(firebaseItemDTO: firebaseItemDTO)

        // Then
        XCTAssertEqual(sut.id, 1)
        XCTAssertFalse(sut.deleted)
        XCTAssertEqual(sut.kind, .story)
        XCTAssertEqual(sut.author, "pg")
        XCTAssertEqual(sut.body, "text")
        XCTAssertFalse(sut.dead)
        XCTAssert(sut.children.isEmpty)
        XCTAssertEqual(
            sut.url,
            URL(string: "http://ycombinator.com")
        )
        XCTAssertEqual(sut.score, 57)
        XCTAssertEqual(sut.title, "Y Combinator")
        XCTAssertEqual(sut.descendants, 15)
        XCTAssert(sut.comments.isEmpty)
        XCTAssertNotNil(sut.markdownBody)
        XCTAssertNotNil(sut.urlSimpleString)
        XCTAssertNotNil(sut.elapsedTimeString)
        XCTAssertEqual(
            sut.hackerNewsURL,
            URL(string: "https://news.ycombinator.com/item?id=1")
        )
    }

    func testInit_givenAlgoliaAndFirebaseItemDTOs() throws {
        // Given
        let algoliaItemDTO = try algoliaItemDTO()
        let firebaseItemDTO = try firebaseItemDTO()
        let filterServiceMock = FilterServiceMock()

        // When
        let sut = Item(
            algoliaItemDTO: algoliaItemDTO,
            firebaseItemDTO: firebaseItemDTO,
            filterService: filterServiceMock
        )

        // Then
        XCTAssertEqual(sut.id, 1)
        XCTAssertFalse(sut.deleted)
        XCTAssertEqual(sut.kind, .story)
        XCTAssertEqual(sut.author, "pg")
        XCTAssertEqual(sut.body, "text")
        XCTAssertFalse(sut.dead)
        XCTAssert(sut.children.isEmpty)
        XCTAssertEqual(
            sut.url,
            URL(string: "http://ycombinator.com")
        )
        XCTAssertEqual(sut.score, 57)
        XCTAssertEqual(sut.title, "Y Combinator")
        XCTAssertEqual(sut.descendants, 15)
        XCTAssertEqual(sut.comments.count, 1)
        XCTAssertNotNil(sut.markdownBody)
        XCTAssertNotNil(sut.urlSimpleString)
        XCTAssertNotNil(sut.elapsedTimeString)
        XCTAssertEqual(
            sut.hackerNewsURL,
            URL(string: "https://news.ycombinator.com/item?id=1")
        )
        XCTAssertEqual(filterServiceMock.filteredItemsCallCount, 2)
    }
}

// MARK: - Private extension

private extension ItemTests {

    // MARK: Methods

    func algoliaItemDTO() throws -> AlgoliaItemDTO {
        try algoliaItemDTO(jsonResourceName: "AlgoliaItemDTO_NoNilProperties")
    }

    func firebaseItemDTO() throws -> FirebaseItemDTO {
        try firebaseItemDTO(jsonResourceName: "FirebaseItemDTO_NoNilProperties")
    }
}
