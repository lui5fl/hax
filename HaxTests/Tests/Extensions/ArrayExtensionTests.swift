//
//  ArrayExtensionTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 21/12/22.
//

import XCTest
@testable import Hax

final class ArrayExtensionTests: XCTestCase {

    // MARK: Properties

    private var sut: [Int]!

    // MARK: Set up and tear down

    override func setUpWithError() throws {
        try super.setUpWithError()

        sut = [0]
    }

    override func tearDownWithError() throws {
        sut = nil

        try super.tearDownWithError()
    }

    // MARK: Tests

    func testSafeSubscript_givenIndexIsLessThanZero() {
        XCTAssertNil(sut[safe: -1])
    }

    func testSafeSubscript_givenIndexIsGreaterThanOrEqualToEndIndex() {
        XCTAssertNil(sut[safe: sut.endIndex + 1])
        XCTAssertNil(sut[safe: sut.endIndex])
    }

    func testSafeSubscript_givenIndexIsWithinBounds() {
        XCTAssertNotNil(sut[safe: 0])
    }
}
