//
//  URLExtensionTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 18/5/22.
//

import XCTest
@testable import Hax

final class URLExtensionTests: XCTestCase {

    // MARK: Tests

    func testSimpleString_givenNoSchemeAndNoSubdirectory() throws {
        // Given
        let sut = try XCTUnwrap(URL(string: "luisfl.me"))

        // When
        let simpleString = sut.simpleString()

        // Then
        XCTAssertEqual(simpleString, "luisfl.me")
    }

    func testSimpleString_givenNoSchemeAndSubdirectory() throws {
        // Given
        let sut = try XCTUnwrap(URL(string: "luisfl.me/subdirectory"))

        // When
        let simpleString = sut.simpleString()

        // Then
        XCTAssertEqual(simpleString, "luisfl.me")
    }

    func testSimpleString_givenSchemeAndNoSubdirectory() throws {
        // Given
        let sut = try XCTUnwrap(URL(string: "https://luisfl.me"))

        // When
        let simpleString = sut.simpleString()

        // Then
        XCTAssertEqual(simpleString, "luisfl.me")
    }

    func testSimpleString_givenSchemeAndSubdirectory() throws {
        // Given
        let sut = try XCTUnwrap(URL(string: "https://luisfl.me/subdirectory"))

        // When
        let simpleString = sut.simpleString()

        // Then
        XCTAssertEqual(simpleString, "luisfl.me")
    }
}
