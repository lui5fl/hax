//
//  FeedViewModelTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 20/12/22.
//

import Combine
import XCTest
@testable import Hax

@MainActor
final class FeedViewModelTests: XCTestCase {

    // MARK: Properties

    private var sut: FeedViewModel!
    private var hackerNewsServiceMock: HackerNewsServiceMock!

    // MARK: Set up and tear down

    override func setUpWithError() throws {
        try super.setUpWithError()

        hackerNewsServiceMock = HackerNewsServiceMock()
        sut = FeedViewModel(
            feed: .top,
            hackerNewsService: hackerNewsServiceMock
        )
    }

    override func tearDownWithError() throws {
        sut = nil
        hackerNewsServiceMock = nil

        try super.tearDownWithError()
    }

    // MARK: Tests

    func testInit() {
        XCTAssertEqual(sut.feed, .top)
        XCTAssert(sut.isLoading)
        XCTAssertNil(sut.error)
        XCTAssertEqual(sut.items, [])
        XCTAssertNil(sut.url)
    }

    func testOnViewAppear_givenItemsRequestFails() async {
        // When
        await sut.onViewAppear()

        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertNotNil(sut.error)
        XCTAssertEqual(sut.items, [])
        XCTAssertEqual(hackerNewsServiceMock.itemsCallCount, 1)
    }

    func testOnViewAppear_givenItemsRequestDoesNotFail() async {
        // Given
        hackerNewsServiceMock.itemsStub = [.example]

        // When
        await sut.onViewAppear()

        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
        XCTAssertEqual(sut.items, [.example])
        XCTAssertEqual(hackerNewsServiceMock.itemsCallCount, 1)
    }

    func testOnViewAppear_whenCalledTwice() async {
        // When
        await sut.onViewAppear()
        await sut.onViewAppear()

        // Then
        XCTAssertEqual(hackerNewsServiceMock.itemsCallCount, 1)
    }

    func testOnItemAppear_givenItemsRequestFails() async {
        // Given
        sut.items = [.example]

        // When
        await sut.onItemAppear(item: .example)

        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertNotNil(sut.error)
        XCTAssertEqual(sut.items, [.example])
        XCTAssertEqual(hackerNewsServiceMock.itemsCallCount, 1)
    }

    func testOnItemAppear_givenItemsRequestDoesNotFail() async {
        // Given
        sut.items = [.example]
        hackerNewsServiceMock.itemsStub = [.example]

        // When
        await sut.onItemAppear(item: .example)

        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
        XCTAssertEqual(sut.items, [.example, .example])
        XCTAssertEqual(hackerNewsServiceMock.itemsCallCount, 1)
    }

    func testOnItemAppear_whenCalledForEveryItemButTheLastOne() async {
        // Given
        sut.items = (0...9).map {
            .example(id: $0)
        }

        // When
        for item in sut.items.dropLast() {
            await sut.onItemAppear(item: item)
        }

        // Then
        XCTAssertEqual(hackerNewsServiceMock.itemsCallCount, 0)
    }

    func testOnRefreshRequest_givenItemsRequestFails() async {
        // Given
        sut.items = [.example, .example]

        // When
        await sut.onRefreshRequest()

        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertNotNil(sut.error)
        XCTAssertEqual(sut.items, [.example, .example])
        XCTAssertEqual(hackerNewsServiceMock.itemsCallCount, 1)
    }

    func testOnRefreshRequest_givenItemsRequestDoesNotFail() async {
        // Given
        sut.items = [.example, .example]
        hackerNewsServiceMock.itemsStub = [.example]

        // When
        await sut.onRefreshRequest()

        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
        XCTAssertEqual(sut.items, [.example])
        XCTAssertEqual(hackerNewsServiceMock.itemsCallCount, 1)
    }
}
