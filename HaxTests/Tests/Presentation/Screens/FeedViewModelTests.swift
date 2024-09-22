//
//  FeedViewModelTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 20/12/22.
//

import Testing
@testable import Hax

@MainActor
struct FeedViewModelTests {

    // MARK: Properties

    private let sut: FeedViewModel
    private let hackerNewsServiceMock: HackerNewsServiceMock

    // MARK: Initialization

    init() {
        hackerNewsServiceMock = HackerNewsServiceMock()
        sut = FeedViewModel(
            feed: .top,
            hackerNewsService: hackerNewsServiceMock
        )
    }

    // MARK: Tests

    @Test func initialize() {
        #expect(sut.feed == .top)
        #expect(sut.isLoading)
        #expect(sut.error == nil)
        #expect(sut.items.isEmpty)
        #expect(sut.url == nil)
    }

    @Test func onViewAppear_givenItemsRequestFails() async {
        // When
        await sut.onViewAppear()

        // Then
        #expect(!sut.isLoading)
        #expect(sut.error != nil)
        #expect(sut.items.isEmpty)
        #expect(await hackerNewsServiceMock.itemsCallCount == 1)
    }

    @Test func onViewAppear_givenItemsRequestDoesNotFail() async {
        // Given
        await hackerNewsServiceMock.itemsStub([.example])

        // When
        await sut.onViewAppear()

        // Then
        #expect(!sut.isLoading)
        #expect(sut.error == nil)
        #expect(sut.items == [.example])
        #expect(await hackerNewsServiceMock.itemsCallCount == 1)
    }

    @Test func onViewAppear_whenCalledTwice() async {
        // When
        await sut.onViewAppear()
        await sut.onViewAppear()

        // Then
        #expect(await hackerNewsServiceMock.itemsCallCount == 1)
    }

    @Test func onItemAppear_givenItemsRequestFails() async {
        // Given
        sut.items = [.example]

        // When
        await sut.onItemAppear(item: .example)

        // Then
        #expect(!sut.isLoading)
        #expect(sut.error != nil)
        #expect(sut.items == [.example])
        #expect(await hackerNewsServiceMock.itemsCallCount == 1)
    }

    @Test func onItemAppear_givenItemsRequestDoesNotFail() async {
        // Given
        sut.items = [.example]
        await hackerNewsServiceMock.itemsStub([.example])

        // When
        await sut.onItemAppear(item: .example)

        // Then
        #expect(!sut.isLoading)
        #expect(sut.error == nil)
        #expect(sut.items == [.example, .example])
        #expect(await hackerNewsServiceMock.itemsCallCount == 1)
    }

    @Test func onItemAppear_whenCalledForEveryItemButTheLastOne() async {
        // Given
        sut.items = (.zero ... 9).map {
            .example(id: $0)
        }

        // When
        for item in sut.items.dropLast() {
            await sut.onItemAppear(item: item)
        }

        // Then
        #expect(await hackerNewsServiceMock.itemsCallCount == .zero)
    }

    @Test func onRefreshRequest_givenItemsRequestFails() async {
        // Given
        sut.items = [.example, .example]

        // When
        await sut.onRefreshRequest()

        // Then
        #expect(!sut.isLoading)
        #expect(sut.error != nil)
        #expect(sut.items == [.example, .example])
        #expect(await hackerNewsServiceMock.itemsCallCount == 1)
    }

    @Test func onRefreshRequest_givenItemsRequestDoesNotFail() async {
        // Given
        sut.items = [.example, .example]
        await hackerNewsServiceMock.itemsStub([.example])

        // When
        await sut.onRefreshRequest()

        // Then
        #expect(!sut.isLoading)
        #expect(sut.error == nil)
        #expect(sut.items == [.example])
        #expect(await hackerNewsServiceMock.itemsCallCount == 1)
    }
}
