//
//  FirebaseUserDTOTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 30/5/24.
//

import XCTest
@testable import Hax

final class FirebaseUserDTOTests: XCTestCase {

    // MARK: Tests

    func testInitFromDecoder_givenNoNilPropertiesJSON() throws {
        // Given
        let jsonResourceName = "FirebaseUserDTO_NoNilProperties"

        // When
        let sut = try firebaseUserDTO(
            jsonResourceName: jsonResourceName
        )

        // Then
        XCTAssertEqual(sut.about, "Bug fixer.")
        XCTAssertEqual(sut.created, 1160418092)
        XCTAssertEqual(sut.id, "pg")
        XCTAssertEqual(sut.karma, 157236)
        XCTAssertEqual(sut.submitted?.count, 1)
    }

    func testInitFromDecoder_givenSomeNilPropertiesJSON() throws {
        // Given
        let jsonResourceName = "FirebaseUserDTO_SomeNilProperties"

        // When
        let sut = try firebaseUserDTO(
            jsonResourceName: jsonResourceName
        )

        // Then
        XCTAssertNil(sut.about)
        XCTAssertEqual(sut.created, 1160418092)
        XCTAssertEqual(sut.id, "pg")
        XCTAssertEqual(sut.karma, 157236)
        XCTAssertNil(sut.submitted)
    }
}
