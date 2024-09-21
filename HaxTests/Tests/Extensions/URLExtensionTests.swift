//
//  URLExtensionTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 18/5/22.
//

import Foundation
import Testing
@testable import Hax

struct URLExtensionTests {

    // MARK: Tests

    @Test func simpleString_givenNoSchemeAndNoSubdirectory() throws {
        // Given
        let sut = try #require(URL(string: "luisfl.me"))

        // When
        let simpleString = sut.simpleString()

        // Then
        #expect(simpleString == "luisfl.me")
    }

    @Test func simpleString_givenNoSchemeAndSubdirectory() throws {
        // Given
        let sut = try #require(URL(string: "luisfl.me/subdirectory"))

        // When
        let simpleString = sut.simpleString()

        // Then
        #expect(simpleString == "luisfl.me")
    }

    @Test func simpleString_givenSchemeAndNoSubdirectory() throws {
        // Given
        let sut = try #require(URL(string: "https://luisfl.me"))

        // When
        let simpleString = sut.simpleString()

        // Then
        #expect(simpleString == "luisfl.me")
    }

    @Test func simpleString_givenSchemeAndSubdirectory() throws {
        // Given
        let sut = try #require(
            URL(string: "https://luisfl.me/subdirectory")
        )

        // When
        let simpleString = sut.simpleString()

        // Then
        #expect(simpleString == "luisfl.me")
    }

    @Test(.bug("https://github.com/lui5fl/hax/issues/38", id: 38))
    func simpleString_givenIPAddress() throws {
        // Given
        let sut = try #require(URL(string: "https://1.1.1.1"))

        // When
        let simpleString = sut.simpleString()

        // Then
        #expect(simpleString == "1.1.1.1")
    }

    @Test(.bug("https://github.com/lui5fl/hax/issues/38", id: 38))
    func simpleString_givenSLD() throws {
        // Given
        let sut = try #require(URL(string: "https://luisfl.co.jp"))

        // When
        let simpleString = sut.simpleString()

        // Then
        #expect(simpleString == "luisfl.co.jp")
    }

    @Test(.bug("https://github.com/lui5fl/hax/issues/38", id: 38))
    func simpleString_givenWWW() throws {
        // Given
        let sut = try #require(URL(string: "https://www.luisfl.me"))

        // When
        let simpleString = sut.simpleString()

        // Then
        #expect(simpleString == "luisfl.me")
    }
}
