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
    private var cancellables: Set<AnyCancellable>!

    // MARK: Set up and tear down

    override func setUpWithError() throws {
        try super.setUpWithError()

        hackerNewsServiceMock = HackerNewsServiceMock()
        sut = FeedViewModel(
            feed: .top,
            hackerNewsService: hackerNewsServiceMock
        )
        cancellables = []
    }

    override func tearDownWithError() throws {
        sut = nil
        hackerNewsServiceMock = nil
        cancellables = nil

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

    func testOnViewAppear_givenItemsRequestFails() {
        // Given
        setUpExpectationForError()

        // When
        sut.onViewAppear()
        waitForExpectations(timeout: 5)

        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertNotNil(sut.error)
        XCTAssertEqual(sut.items, [])
        XCTAssertEqual(hackerNewsServiceMock.itemsCallCount, 1)
    }

    func testOnViewAppear_givenItemsRequestDoesNotFail() {
        // Given
        hackerNewsServiceMock.itemsStub = [.example]
        setUpExpectationForIsLoading()

        // When
        sut.onViewAppear()
        waitForExpectations(timeout: 5)

        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
        XCTAssertEqual(sut.items, [.example])
        XCTAssertEqual(hackerNewsServiceMock.itemsCallCount, 1)
    }

    func testOnViewAppear_whenCalledTwice() {
        // Given
        setUpExpectationForIsLoading()

        // When
        sut.onViewAppear()
        sut.onViewAppear()
        waitForExpectations(timeout: 5)

        // Then
        XCTAssertEqual(hackerNewsServiceMock.itemsCallCount, 1)
    }

    func testOnItemAppear_givenItemsRequestFails() {
        // Given
        sut.items = [.example]
        setUpExpectationForError()

        // When
        sut.onItemAppear(item: .example)
        waitForExpectations(timeout: 5)

        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertNotNil(sut.error)
        XCTAssertEqual(sut.items, [.example])
        XCTAssertEqual(hackerNewsServiceMock.itemsCallCount, 1)
    }

    func testOnItemAppear_givenItemsRequestDoesNotFail() {
        // Given
        sut.items = [.example]
        hackerNewsServiceMock.itemsStub = [.example]
        setUpExpectationForIsLoading()

        // When
        sut.onItemAppear(item: .example)
        waitForExpectations(timeout: 5)

        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
        XCTAssertEqual(sut.items, [.example, .example])
        XCTAssertEqual(hackerNewsServiceMock.itemsCallCount, 1)
    }

    func testOnItemAppear_whenCalledForEveryItemButTheLastOne() {
        // Given
        sut.items = (0...9).map {
            .example(id: $0)
        }

        // When
        for item in sut.items.dropLast() {
            sut.onItemAppear(item: item)
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

// MARK: - Private extension

private extension FeedViewModelTests {

    // MARK: Methods

    func setUpExpectationForIsLoading() {
        expectation(
            publishedProperty: sut.$isLoading,
            description: "isLoading"
        )
        .store(in: &cancellables)
    }

    func setUpExpectationForError() {
        expectation(
            publishedProperty: sut.$error,
            description: "error"
        )
        .store(in: &cancellables)
    }
}
