//
//  UserViewModelTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 1/6/24.
//

import XCTest
@testable import Hax

@MainActor
final class UserViewModelTests: XCTestCase {

    // MARK: Properties

    private var sut: UserViewModel!
    private var hackerNewsServiceMock: HackerNewsServiceMock!

    // MARK: Set up and tear down

    override func setUp() {
        super.setUp()

        hackerNewsServiceMock = HackerNewsServiceMock()
        sut = UserViewModel(
            id: "pg",
            hackerNewsService: hackerNewsServiceMock
        )
    }

    override func tearDown() {
        sut = nil
        hackerNewsServiceMock = nil

        super.tearDown()
    }

    // MARK: Tests

    func testInit() {
        XCTAssertNil(sut.error)
        XCTAssertNil(sut.user)
        XCTAssertNil(sut.url)
    }

    func testOnViewAppear_givenUserRequestFails() async {
        // When
        await sut.onViewAppear()

        // Then
        XCTAssertNotNil(sut.error)
        XCTAssertNil(sut.user)
        XCTAssertEqual(hackerNewsServiceMock.userCallCount, 1)
    }

    func testOnViewAppear_givenUserRequestDoesNotFail() async {
        // Given
        hackerNewsServiceMock.userStub = User(
            id: "pg",
            creationDate: .now,
            karma: .zero
        )

        // When
        await sut.onViewAppear()

        // Then
        XCTAssertNil(sut.error)
        XCTAssertNotNil(sut.user)
        XCTAssertEqual(hackerNewsServiceMock.userCallCount, 1)
    }

    func testOnLinkTap_givenSchemeDoesNotStartWithHTTP() throws {
        // Given
        let url = try XCTUnwrap(URL(string: "example@example.com"))

        // When
        _ = sut.onLinkTap(url: url)

        // Then
        XCTAssertNil(sut.url)
    }

    func testOnLinkTap_givenSchemeStartsWithHTTP() throws {
        // Given
        let url = try XCTUnwrap(URL(string: "https://luisfl.me"))

        // When
        _ = sut.onLinkTap(url: url)

        // Then
        XCTAssertEqual(sut.url?.url, url)
    }
}
