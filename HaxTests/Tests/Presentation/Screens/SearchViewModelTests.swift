//
//  SearchViewModelTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 9/9/24.
//

import Testing
@testable import Hax

@MainActor
struct SearchViewModelTests {

    // MARK: Properties

    private let sut: SearchViewModel
    private let hackerNewsServiceMock: HackerNewsServiceMock

    // MARK: Initialization

    init() {
        hackerNewsServiceMock = HackerNewsServiceMock()
        sut = SearchViewModel(
            hackerNewsService: hackerNewsServiceMock
        )
    }

    // MARK: Tests

    @Test func initialize() {
        #expect(!sut.isLoading)
        #expect(sut.error == nil)
        #expect(sut.items.isEmpty)
        #expect(sut.text.isEmpty)
    }

    @Test func onSubmit_givenSearchRequestFails() async {
        // When
        await sut.onSubmit()

        // Then
        #expect(!sut.isLoading)
        #expect(sut.error != nil)
        #expect(sut.items.isEmpty)
        #expect(sut.text.isEmpty)
        #expect(hackerNewsServiceMock.searchCallCount == 1)
    }

    @Test func onSubmit_givenSearchRequestDoesNotFail() async {
        // Given
        let items = [Item.example]
        hackerNewsServiceMock.searchStub = { _ in
            items
        }

        // When
        await sut.onSubmit()

        // Then
        #expect(!sut.isLoading)
        #expect(sut.error == nil)
        #expect(sut.items == items)
        #expect(sut.text.isEmpty)
        #expect(hackerNewsServiceMock.searchCallCount == 1)
    }
}
