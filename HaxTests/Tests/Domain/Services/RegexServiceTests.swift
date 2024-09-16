//
//  RegexServiceTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 20/3/24.
//

import Foundation
import Testing
@testable import Hax

struct RegexServiceTests {

    // MARK: Properties

    private let sut = RegexService()

    // MARK: Tests

    @Test func itemID_givenURLIsNotValid() throws {
        // Given
        let url = try #require(URL(string: "https://luisfl.me"))

        // When
        let itemID = sut.itemID(url: url)

        // Then
        #expect(itemID == nil)
    }

    @Test func itemID_givenURLIsValidDeepLink() throws {
        // Given
        let url = try #require(URL(string: "hax://item/39763750"))

        // When
        let itemID = sut.itemID(url: url)

        // Then
        #expect(itemID == 39763750)
    }

    @Test func itemID_givenURLIsValidHackerNewsLink() throws {
        // Given
        let url = try #require(
            URL(
                string: "https://news.ycombinator.com/item?id=39763750"
            )
        )

        // When
        let itemID = sut.itemID(url: url)

        // Then
        #expect(itemID == 39763750)
    }

    @Test func userID_givenURLIsNotValid() throws {
        // Given
        let url = try #require(URL(string: "https://luisfl.me"))

        // When
        let userID = sut.userID(url: url)

        // Then
        #expect(userID == nil)
    }

    @Test func userID_givenURLIsValidDeepLink() throws {
        // Given
        let url = try #require(URL(string: "hax://user/pg"))

        // When
        let userID = sut.userID(url: url)

        // Then
        #expect(userID == "pg")
    }

    @Test func userID_givenURLIsValidHackerNewsLink() throws {
        // Given
        let url = try #require(
            URL(string: "https://news.ycombinator.com/user?id=pg")
        )

        // When
        let userID = sut.userID(url: url)

        // Then
        #expect(userID == "pg")
    }
}
