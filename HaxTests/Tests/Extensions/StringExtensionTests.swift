//
//  StringExtensionTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 25/4/24.
//

import Testing
@testable import Hax

struct StringExtensionTests {

    // MARK: Tests

    @Test func containsWord_givenStringDoesNotContainWord() {
        // Given
        let sut = "Thisstringdoesnotcontaintheword."

        // When
        let containsWord = sut.contains(word: "word")

        // Then
        #expect(!containsWord)
    }

    @Test func containsWord_givenStringContainsWord() {
        // Given
        let sut = "This string contains the word."

        // When
        let containsWord = sut.contains(word: "word")

        // Then
        #expect(containsWord)
    }
}
