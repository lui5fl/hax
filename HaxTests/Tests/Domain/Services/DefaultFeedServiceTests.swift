//
//  DefaultFeedServiceTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 20/12/22.
//

import Testing
@testable import Hax

struct DefaultFeedServiceTests {

    // MARK: Properties

    private let sut: DefaultFeedService
    private let userDefaultsMock: UserDefaultsMock
    private let userDefaultsKey = "defaultFeed"

    // MARK: Initialization

    init() {
        userDefaultsMock = UserDefaultsMock()
        sut = DefaultFeedService(
            userDefaults: userDefaultsMock,
            userDefaultsKey: userDefaultsKey
        )
    }

    // MARK: Tests

    @Test func defaultFeed_givenDefaultFeedIsNotValid() {
        // Given
        setDefaultFeed(rawValue: "invalidFeed")

        // When
        let defaultFeed = sut.defaultFeed()

        // Then
        #expect(defaultFeed == nil)
        #expect(userDefaultsMock.stringCallCount == 1)
    }

    @Test func defaultFeed_givenDefaultFeedIsValid() {
        // Given
        setDefaultFeed(rawValue: "best")

        // When
        let defaultFeed = sut.defaultFeed()

        // Then
        #expect(defaultFeed == .best)
        #expect(userDefaultsMock.stringCallCount == 1)
    }
}

// MARK: - Private extension

private extension DefaultFeedServiceTests {

    // MARK: Methods

    func setDefaultFeed(rawValue: String) {
        userDefaultsMock.set(rawValue, forKey: userDefaultsKey)
    }
}
