//
//  MenuViewModelTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 20/12/22.
//

import XCTest
@testable import Hax

@MainActor
final class MenuViewModelTests: XCTestCase {

    // MARK: Properties

    private var sut: MenuViewModel!
    private var regexServiceMock: RegexServiceMock!

    // MARK: Set up and tear down

    override func setUpWithError() throws {
        try super.setUpWithError()

        regexServiceMock = RegexServiceMock()
        sut = MenuViewModel(regexService: regexServiceMock)
    }

    override func tearDownWithError() throws {
        sut = nil
        regexServiceMock = nil

        try super.tearDownWithError()
    }

    // MARK: Tests

    func testInit() {
        XCTAssertEqual(sut.feeds, Feed.allCases)
        XCTAssertNil(sut.error)
        XCTAssertFalse(sut.openHackerNewsLinkAlertIsPresented)
        XCTAssertEqual(sut.openHackerNewsLinkAlertText, "")
        XCTAssertEqual(regexServiceMock.itemIDCallCount, 0)
    }

    func testItemForHackerNewsLink_givenLinkIsNotAValidURL() {
        // When
        let itemForHackerNewsLink = sut.itemForHackerNewsLink()

        // Then
        XCTAssertNil(itemForHackerNewsLink)
        XCTAssertNotNil(sut.error)
        XCTAssertEqual(sut.openHackerNewsLinkAlertText, "")
        XCTAssertEqual(regexServiceMock.itemIDCallCount, 0)
    }

    func testItemForHackerNewsLink_givenLinkHasNoHackerNewsItemIdentifier() {
        // Given
        sut.openHackerNewsLinkAlertText = "https://luisfl.me"

        // When
        let itemForHackerNewsLink = sut.itemForHackerNewsLink()

        // Then
        XCTAssertNil(itemForHackerNewsLink)
        XCTAssertNotNil(sut.error)
        XCTAssertEqual(sut.openHackerNewsLinkAlertText, "")
        XCTAssertEqual(regexServiceMock.itemIDCallCount, 1)
    }

    func testItemForHackerNewsLink_givenLinkHasHackerNewsItemIdentifier() {
        // Given
        sut.openHackerNewsLinkAlertText = "news.ycombinator.com/item?id=1"
        regexServiceMock.itemIDStub = 1

        // When
        let itemForHackerNewsLink = sut.itemForHackerNewsLink()

        // Then
        XCTAssertEqual(itemForHackerNewsLink?.id, 1)
        XCTAssertNil(sut.error)
        XCTAssertEqual(sut.openHackerNewsLinkAlertText, "")
        XCTAssertEqual(regexServiceMock.itemIDCallCount, 1)
    }
}
