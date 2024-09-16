//
//  IdentifiableStringTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 5/6/24.
//

import Testing
@testable import Hax

struct IdentifiableStringTests {

    // MARK: Tests

    @Test func initialize() {
        // Given
        let string = "string"

        // When
        let sut = IdentifiableString(string)

        // Then
        #expect(sut.string == string)
        #expect(sut.id == string)
    }
}
