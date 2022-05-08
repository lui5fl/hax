//
//  URLExtensionTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 18/5/22.
//

import XCTest
@testable import Hax

final class URLExtensionTests: XCTestCase {

    // MARK: Properties

    private static var expectedValue: String!

    // MARK: Set up and tear down

    override class func setUp() {
        super.setUp()

        expectedValue = "luisfl.me"
    }

    override class func tearDown() {
        expectedValue = nil

        super.tearDown()
    }

    // MARK: Tests

    func testSimpleString_givenNoSchemeAndNoSubdirectory() {
        let sut = URL(string: "luisfl.me")

        XCTAssertEqual(sut?.simpleString(), Self.expectedValue)
    }

    func testSimpleString_givenNoSchemeAndSubdirectory() {
        let sut = URL(string: "luisfl.me/subdirectory")

        XCTAssertEqual(sut?.simpleString(), Self.expectedValue)
    }

    func testSimpleString_givenSchemeAndNoSubdirectory() {
        let sut = URL(string: "https://luisfl.me")

        XCTAssertEqual(sut?.simpleString(), Self.expectedValue)
    }

    func testSimpleString_givenSchemeAndSubdirectory() {
        let sut = URL(string: "https://luisfl.me/subdirectory")

        XCTAssertEqual(sut?.simpleString(), Self.expectedValue)
    }
}
