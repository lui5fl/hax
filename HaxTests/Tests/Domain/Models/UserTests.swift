//
//  UserTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 31/5/24.
//

import XCTest
@testable import Hax

final class UserTests: XCTestCase {

    // MARK: Tests

    func testInit_givenFirebaseUserDTO() throws {
        // Given
        let firebaseUserDTO = try firebaseUserDTO(
            jsonResourceName: "FirebaseUserDTO_NoNilProperties"
        )

        // When
        let sut = User(firebaseUserDTO: firebaseUserDTO)

        // Then
        XCTAssertEqual(sut.id, "pg")
        XCTAssertEqual(
            sut.creationDate,
            Date(timeIntervalSince1970: 1160418092)
        )
        XCTAssertEqual(sut.karma, 157236)
        XCTAssertEqual(sut.description, "Bug fixer.")
        XCTAssertEqual(
            sut.url,
            URL(string: "https://news.ycombinator.com/user?id=pg")
        )
    }
}
