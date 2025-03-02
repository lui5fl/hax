//
//  ReadItemsTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 27/2/25.
//

import Testing
@testable import Hax

@MainActor
struct ReadItemsTests {

    // MARK: Properties

    private let sut: ReadItems
    private let userDefaultsMock: UserDefaultsMock

    // MARK: Initialization

    init() {
        userDefaultsMock = UserDefaultsMock()
        userDefaultsMock.set([1, 2], forKey: "readItems")
        sut = ReadItems(userDefaults: userDefaultsMock, limit: 3)
    }

    // MARK: Tests

    @Test func add_givenItemIsNotReadAndLimitIsNotExceeded() {
        // When
        sut.add(3)

        // Then
        for itemIdentifier in [1, 2, 3] {
            #expect(sut.contains(itemIdentifier))
        }
        #expect(userDefaultsMock.setCallCount == 2)
    }

    @Test func add_givenItemIsNotReadAndLimitIsExceeded() {
        // Given
        sut.add(3)

        // When
        sut.add(4)

        // Then
        for itemIdentifier in [2, 3, 4] {
            #expect(sut.contains(itemIdentifier))
        }
        #expect(userDefaultsMock.setCallCount == 3)
    }

    @Test func add_givenItemIsRead() {
        // Given
        sut.add(3)

        // When
        sut.add(1)

        // Then
        for itemIdentifier in [2, 3, 1] {
            #expect(sut.contains(itemIdentifier))
        }
        #expect(userDefaultsMock.setCallCount == 3)
    }

    @Test func contains_givenItemIsNotRead() {
        // When
        let contains = sut.contains(3)

        // Then
        #expect(!contains)
        #expect(userDefaultsMock.setCallCount == 1)
    }

    @Test func contains_givenItemIsRead() {
        // Given
        sut.add(3)

        // When
        let contains = sut.contains(3)

        // Then
        #expect(contains)
        #expect(userDefaultsMock.setCallCount == 2)
    }
}
