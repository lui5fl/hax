//
//  MenuViewModelTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 20/12/22.
//

import Testing
@testable import Hax

@MainActor
struct MenuViewModelTests {

    // MARK: Properties

    private let sut: MenuViewModel
    private let regexServiceMock: RegexServiceMock

    // MARK: Initialization

    init() {
        regexServiceMock = RegexServiceMock()
        sut = MenuViewModel(regexService: regexServiceMock)
    }

    // MARK: Tests

    @Test func initialize() {
        #expect(sut.feeds == Feed.allCases)
        #expect(sut.error == nil)
        #expect(!sut.openHackerNewsLinkAlertIsPresented)
        #expect(sut.openHackerNewsLinkAlertText.isEmpty)
        #expect(!sut.viewUserAlertIsPresented)
        #expect(sut.viewUserAlertText.isEmpty)
        #expect(regexServiceMock.itemIDCallCount == .zero)
    }

    @Test func itemForHackerNewsLink_givenLinkIsNotAValidURL() {
        // When
        let itemForHackerNewsLink = sut.itemForHackerNewsLink()

        // Then
        #expect(itemForHackerNewsLink == nil)
        #expect(sut.error != nil)
        #expect(sut.openHackerNewsLinkAlertText.isEmpty)
        #expect(regexServiceMock.itemIDCallCount == .zero)
    }

    @Test func itemForHackerNewsLink_givenLinkHasNoHackerNewsItemIdentifier() {
        // Given
        sut.openHackerNewsLinkAlertText = "https://luisfl.me"

        // When
        let itemForHackerNewsLink = sut.itemForHackerNewsLink()

        // Then
        #expect(itemForHackerNewsLink == nil)
        #expect(sut.error != nil)
        #expect(sut.openHackerNewsLinkAlertText.isEmpty)
        #expect(regexServiceMock.itemIDCallCount == 1)
    }

    @Test func itemForHackerNewsLink_givenLinkHasHackerNewsItemIdentifier() {
        // Given
        sut.openHackerNewsLinkAlertText = "news.ycombinator.com/item?id=1"
        regexServiceMock.itemIDStub = 1

        // When
        let itemForHackerNewsLink = sut.itemForHackerNewsLink()

        // Then
        #expect(itemForHackerNewsLink?.id == 1)
        #expect(sut.error == nil)
        #expect(sut.openHackerNewsLinkAlertText.isEmpty)
        #expect(regexServiceMock.itemIDCallCount == 1)
    }
}
