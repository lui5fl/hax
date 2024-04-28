//
//  StringExtensionTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 25/4/24.
//

import XCTest
@testable import Hax

final class StringExtensionTests: XCTestCase {

    // MARK: Tests

    func testContainsWord_givenStringDoesNotContainWord() {
        // Given
        let sut = "Thisstringdoesnotcontaintheword."

        // When
        let containsWord = sut.contains(word: "word")

        // Then
        XCTAssertFalse(containsWord)
    }

    func testContainsWord_givenStringContainsWord() {
        // Given
        let sut = "This string contains the word."

        // When
        let containsWord = sut.contains(word: "word")

        // Then
        XCTAssert(containsWord)
    }
}
