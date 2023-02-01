//
//  IdentifiableURLTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 21/12/22.
//

import XCTest
@testable import Hax

final class IdentifiableURLTests: XCTestCase {

    // MARK: Tests

    func testInit_givenURLIsNil() {
        // When
        let sut = IdentifiableURL(nil)

        // Then
        XCTAssertNil(sut)
    }

    func testInit_givenURLIsNotNil() throws {
        // Given
        let url = try XCTUnwrap(URL(string: "luisfl.me"))

        // When
        let sut = IdentifiableURL(url)

        // Then
        XCTAssertEqual(sut?.url, url)
    }
}
