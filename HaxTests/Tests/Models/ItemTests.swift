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

    func testInitFromDecoder_givenJSONWithAllProperties() throws {
        // Given
        let path = try XCTUnwrap(
            Bundle(for: Self.self)
                .path(
                    forResource: "Item",
                    ofType: "json"
                )
        )
        let string = try String(contentsOfFile: path)

        // When
        let sut = try item(from: string)

        // Then
        XCTAssertEqual(sut.id, 9)
        XCTAssert(sut.deleted)
        XCTAssertEqual(sut.kind, .story)
        XCTAssertEqual(sut.author, "luisfl")
        XCTAssertEqual(sut.date?.timeIntervalSince1970, 1659630601)
        XCTAssertEqual(sut.body, "This is the body")
        XCTAssert(sut.dead)
        XCTAssertEqual(sut.children, [10])
        XCTAssertEqual(sut.url, URL(string: "https://luisfl.me"))
        XCTAssertEqual(sut.score, 42)
        XCTAssertEqual(sut.title, "This is the title")
        XCTAssertEqual(sut.descendants, 98)
    }

    func testInitFromDecoder_givenJSONWithoutOptionalProperties() throws {
        // Given
        let string = "{\"id\": 9}"

        // When
        let sut = try item(from: string)

        // Then
        XCTAssertEqual(sut.id, 9)
        XCTAssertFalse(sut.deleted)
        XCTAssertNil(sut.kind)
        XCTAssertNil(sut.author)
        XCTAssertNil(sut.date)
        XCTAssertNil(sut.body)
        XCTAssertFalse(sut.dead)
        XCTAssertEqual(sut.children, [])
        XCTAssertNil(sut.url)
        XCTAssertNil(sut.score)
        XCTAssertNil(sut.title)
        XCTAssertNil(sut.descendants)
    }
}

// MARK: - Private extension

private extension ItemTests {

    // MARK: Methods

    func item(from string: String) throws -> Item {
        let data = try XCTUnwrap(string.data(using: .utf8))
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        let item = try decoder.decode(Item.self, from: data)

        return item
    }
}
