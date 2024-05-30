//
//  IdentifiableStringTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 5/6/24.
//

import XCTest
@testable import Hax

final class IdentifiableStringTests: XCTestCase {

    // MARK: Tests

    func testInit() {
        // Given
        let string = "string"

        // When
        let sut = IdentifiableString(string)

        // Then
        XCTAssertEqual(sut.string, string)
        XCTAssertEqual(sut.id, string)
    }
}
