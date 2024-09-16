//
//  IdentifiableURLTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 21/12/22.
//

import Foundation
import Testing
@testable import Hax

struct IdentifiableURLTests {

    // MARK: Tests

    @Test func initialize_givenURLIsNil() {
        // When
        let sut = IdentifiableURL(nil)

        // Then
        #expect(sut == nil)
    }

    @Test func initialize_givenURLIsNotNil() throws {
        // Given
        let url = try #require(URL(string: "luisfl.me"))

        // When
        let sut = IdentifiableURL(url)

        // Then
        #expect(sut?.url == url)
    }
}
