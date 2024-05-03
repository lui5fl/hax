//
//  DefaultFeedServiceTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 20/12/22.
//

import XCTest
@testable import Hax

final class DefaultFeedServiceTests: XCTestCase {

    // MARK: Properties

    private var sut: DefaultFeedService!
    private var userDefaultsMock: UserDefaultsMock!

    // MARK: Set up and tear down

    override func setUpWithError() throws {
        try super.setUpWithError()

        userDefaultsMock = UserDefaultsMock()
        sut = DefaultFeedService(
            userDefaults: userDefaultsMock,
            userDefaultsKey: Constant.userDefaultsKey
        )
    }

    override func tearDownWithError() throws {
        sut = nil
        userDefaultsMock = nil

        try super.tearDownWithError()
    }

    // MARK: Tests

    func testDefaultFeed_givenDefaultFeedIsNotValid() {
        // Given
        setDefaultFeed(rawValue: "invalidFeed")

        // When
        let defaultFeed = sut.defaultFeed()

        // Then
        XCTAssertNil(defaultFeed)
        XCTAssertEqual(userDefaultsMock.stringCallCount, 1)
    }

    func testDefaultFeed_givenDefaultFeedIsValid() {
        // Given
        setDefaultFeed(rawValue: "best")

        // When
        let defaultFeed = sut.defaultFeed()

        // Then
        XCTAssertEqual(defaultFeed, .best)
        XCTAssertEqual(userDefaultsMock.stringCallCount, 1)
    }
}

// MARK: - Private extension

private extension DefaultFeedServiceTests {

    // MARK: Types

    enum Constant {
        static let userDefaultsKey = "defaultFeed"
    }

    // MARK: Methods

    func setDefaultFeed(rawValue: String) {
        userDefaultsMock.set(
            rawValue,
            forKey: Constant.userDefaultsKey
        )
    }
}
