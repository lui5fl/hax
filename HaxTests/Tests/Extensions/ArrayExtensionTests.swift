//
//  ArrayExtensionTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 21/12/22.
//

import Testing
@testable import Hax

struct ArrayExtensionTests {

    // MARK: Properties

    private let sut = [Int.zero]

    // MARK: Tests

    @Test func safeSubscript_givenIndexIsLessThanZero() {
        #expect(sut[safe: -1] == nil)
    }

    @Test func safeSubscript_givenIndexIsGreaterThanOrEqualToEndIndex() {
        #expect(sut[safe: sut.endIndex + 1] == nil)
        #expect(sut[safe: sut.endIndex] == nil)
    }

    @Test func safeSubscript_givenIndexIsWithinBounds() {
        #expect(sut[safe: .zero] != nil)
    }
}
