//
//  RegexServiceTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 20/3/24.
//

import XCTest
@testable import Hax

final class RegexServiceTests: XCTestCase {

    // MARK: Properties

    private var sut: RegexService!

    // MARK: Set up and tear down

    override func setUpWithError() throws {
        try super.setUpWithError()

        sut = RegexService()
    }

    override func tearDownWithError() throws {
        sut = nil

        try super.tearDownWithError()
    }

    // MARK: Tests

    func testItemID_givenURLIsNotValid() throws {
        // Given
        let url = try XCTUnwrap(URL(string: "https://luisfl.me"))

        // When
        let itemID = sut.itemID(url: url)

        // Then
        XCTAssertNil(itemID)
    }

    func testItemID_givenURLIsValidDeepLink() throws {
        // Given
        let url = try XCTUnwrap(URL(string: "hax://item/39763750"))

        // When
        let itemID = sut.itemID(url: url)

        // Then
        XCTAssertEqual(itemID, 39763750)
    }

    func testItemID_givenURLIsValidHackerNewsLink() throws {
        // Given
        let url = try XCTUnwrap(URL(string: "https://news.ycombinator.com/item?id=39763750"))

        // When
        let itemID = sut.itemID(url: url)

        // Then
        XCTAssertEqual(itemID, 39763750)
    }
}
