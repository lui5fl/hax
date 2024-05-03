//
//  FirebaseItemDTOTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 12/5/24.
//

import XCTest
@testable import Hax

final class FirebaseItemDTOTests: XCTestCase {

    // MARK: Tests

    func testInitFromDecoder_givenNoNilPropertiesJSON() throws {
        // Given
        let jsonResourceName = "FirebaseItemDTO_NoNilProperties"

        // When
        let sut = try firebaseItemDTO(jsonResourceName: jsonResourceName)

        // Then
        XCTAssertEqual(sut.by, "pg")
        XCTAssertEqual(sut.dead, false)
        XCTAssertEqual(sut.deleted, false)
        XCTAssertEqual(sut.descendants, 15)
        XCTAssertEqual(sut.id, 1)
        XCTAssertEqual(sut.kids?.count, 4)
        XCTAssertEqual(sut.parent, 42)
        XCTAssertEqual(sut.parts?.count, 1)
        XCTAssertEqual(sut.poll, 42)
        XCTAssertEqual(sut.score, 57)
        XCTAssertEqual(sut.text, "text")
        XCTAssertEqual(sut.time, 1160418111)
        XCTAssertEqual(sut.title, "Y Combinator")
        XCTAssertEqual(sut.type, "story")
        XCTAssertEqual(sut.url, "http://ycombinator.com")
    }

    func testInitFromDecoder_givenSomeNilPropertiesJSON() throws {
        // Given
        let jsonResourceName = "FirebaseItemDTO_SomeNilProperties"

        // When
        let sut = try firebaseItemDTO(jsonResourceName: jsonResourceName)

        // Then
        XCTAssertNil(sut.by)
        XCTAssertNil(sut.dead)
        XCTAssertNil(sut.deleted)
        XCTAssertNil(sut.descendants)
        XCTAssertEqual(sut.id, 42)
        XCTAssertNil(sut.kids)
        XCTAssertNil(sut.parent)
        XCTAssertNil(sut.parts)
        XCTAssertNil(sut.poll)
        XCTAssertNil(sut.score)
        XCTAssertNil(sut.text)
        XCTAssertNil(sut.time)
        XCTAssertNil(sut.title)
        XCTAssertNil(sut.type)
        XCTAssertNil(sut.url)
    }
}
