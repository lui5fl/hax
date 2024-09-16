//
//  UserViewModelTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 1/6/24.
//

import Foundation
import Testing
@testable import Hax

@MainActor
struct UserViewModelTests {

    // MARK: Properties

    private let sut: UserViewModel
    private let hackerNewsServiceMock: HackerNewsServiceMock

    // MARK: Initialization

    init() {
        hackerNewsServiceMock = HackerNewsServiceMock()
        sut = UserViewModel(
            id: "pg",
            hackerNewsService: hackerNewsServiceMock
        )
    }

    // MARK: Tests

    @Test func initialize() {
        #expect(sut.error == nil)
        #expect(sut.user == nil)
        #expect(sut.url == nil)
    }

    @Test func onViewAppear_givenUserRequestFails() async {
        // When
        await sut.onViewAppear()

        // Then
        #expect(sut.error != nil)
        #expect(sut.user == nil)
        #expect(hackerNewsServiceMock.userCallCount == 1)
    }

    @Test func onViewAppear_givenUserRequestDoesNotFail() async {
        // Given
        hackerNewsServiceMock.userStub = User(
            id: "pg",
            creationDate: .now,
            karma: .zero
        )

        // When
        await sut.onViewAppear()

        // Then
        #expect(sut.error == nil)
        #expect(sut.user != nil)
        #expect(hackerNewsServiceMock.userCallCount == 1)
    }

    @Test func onLinkTap_givenSchemeDoesNotStartWithHTTP() throws {
        // Given
        let url = try #require(URL(string: "example@example.com"))

        // When
        _ = sut.onLinkTap(url: url)

        // Then
        #expect(sut.url == nil)
    }

    @Test func onLinkTap_givenSchemeStartsWithHTTP() throws {
        // Given
        let url = try #require(URL(string: "https://luisfl.me"))

        // When
        _ = sut.onLinkTap(url: url)

        // Then
        #expect(sut.url?.url == url)
    }
}
