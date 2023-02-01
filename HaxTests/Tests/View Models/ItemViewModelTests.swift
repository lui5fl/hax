//
//  ItemViewModelTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 22/12/22.
//

import Combine
import XCTest
@testable import Hax

@MainActor
final class ItemViewModelTests: XCTestCase {

    // MARK: Properties

    private var sut: ItemViewModel!
    private var hackerNewsServiceMock: HackerNewsServiceMock!
    private var cancellables: Set<AnyCancellable>!

    // MARK: Set up and tear down

    override func setUpWithError() throws {
        try super.setUpWithError()

        hackerNewsServiceMock = HackerNewsServiceMock()
        sut = ItemViewModel(
            item: .example,
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
        XCTAssert(sut.isLoading)
        XCTAssertNil(sut.error)
        XCTAssertEqual(sut.item, .example)
        XCTAssertEqual(sut.comments, [])
        XCTAssertNil(sut.url)
        XCTAssertEqual(sut.title, "98 comments")
    }

    func testOnViewAppear_givenItemRequestFails() {
        // Given
        setUpExpectationForError()

        // When
        sut.onViewAppear()
        waitForExpectations(timeout: 5)

        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertNotNil(sut.error)
        XCTAssertEqual(sut.item, .example)
        XCTAssertEqual(sut.comments, [])
        XCTAssertEqual(hackerNewsServiceMock.itemCallCount, 1)
        XCTAssertEqual(hackerNewsServiceMock.commentsCallCount, 0)
    }

    func testOnViewAppear_givenItemRequestDoesNotFailButCommentsRequestDoes() {
        // Given
        let item = Item.example(id: 1)
        hackerNewsServiceMock.itemStub = item
        setUpExpectationForError()

        // When
        sut.onViewAppear()
        waitForExpectations(timeout: 5)

        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertNotNil(sut.error)
        XCTAssertEqual(sut.item, item)
        XCTAssertEqual(sut.comments, [])
        XCTAssertEqual(hackerNewsServiceMock.itemCallCount, 1)
        XCTAssertEqual(hackerNewsServiceMock.commentsCallCount, 1)
    }

    func testOnViewAppear_givenItemAndCommentsRequestsDoNotFail() {
        // Given
        let item = Item.example(id: 1)
        hackerNewsServiceMock.itemStub = item
        hackerNewsServiceMock.commentsStub = [.example]
        setUpExpectationForIsLoading()

        // When
        sut.onViewAppear()
        waitForExpectations(timeout: 5)

        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
        XCTAssertEqual(sut.item, item)
        XCTAssertEqual(sut.comments, [.example])
        XCTAssertEqual(hackerNewsServiceMock.itemCallCount, 1)
        XCTAssertEqual(hackerNewsServiceMock.commentsCallCount, 1)
    }

    func testOnCommentAppear_givenCommentsRequestFails() {
        // Given
        sut.comments = [.example]
        setUpExpectationForError()

        // When
        sut.onCommentAppear(comment: .example)
        waitForExpectations(timeout: 5)

        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertNotNil(sut.error)
        XCTAssertEqual(sut.comments, [.example])
        XCTAssertEqual(hackerNewsServiceMock.commentsCallCount, 1)
    }

    func testOnCommentAppear_givenCommentsRequestDoesNotFail() {
        // Given
        sut.comments = [.example]
        hackerNewsServiceMock.commentsStub = [.example]
        setUpExpectationForIsLoading()

        // When
        sut.onCommentAppear(comment: .example)
        waitForExpectations(timeout: 5)

        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
        XCTAssertEqual(sut.comments, [.example, .example])
        XCTAssertEqual(hackerNewsServiceMock.commentsCallCount, 1)
    }

    func testOnCommentAppear_whenCalledForEveryCommentButTheLastOne() {
        // Given
        sut.comments = (0...9).map {
            .example(id: $0)
        }

        // When
        for comment in sut.comments.dropLast() {
            sut.onCommentAppear(comment: comment)
        }

        // Then
        XCTAssertEqual(hackerNewsServiceMock.commentsCallCount, 0)
    }

    func testOnCommentTap_givenCommentIsNotInComments() {
        // Given
        hackerNewsServiceMock.itemStub = .example
        hackerNewsServiceMock.commentsStub = [
            .example(id: 0, depth: 0),
            .example(id: 1, depth: 1),
            .example(id: 2, depth: 2),
            .example(id: 3, depth: 1)
        ]
        setUpExpectationForIsLoading()
        sut.onViewAppear()
        waitForExpectations(timeout: 5)

        // When
        sut.onCommentTap(comment: .example(id: 4))

        // Then
        XCTAssertEqual(
            sut.comments,
            [
                .example(id: 0, depth: 0),
                .example(id: 1, depth: 1),
                .example(id: 2, depth: 2),
                .example(id: 3, depth: 1)
            ]
        )
    }

    func testOnCommentTap_givenCommentIsInComments() {
        // Given
        hackerNewsServiceMock.itemStub = .example
        hackerNewsServiceMock.commentsStub = [
            .example(id: 0, depth: 0),
            .example(id: 1, depth: 1),
            .example(id: 2, depth: 2),
            .example(id: 3, depth: 1)
        ]
        setUpExpectationForIsLoading()
        sut.onViewAppear()
        waitForExpectations(timeout: 5)

        // When
        sut.onCommentTap(comment: .example(id: 1, depth: 1))

        // Then
        XCTAssertEqual(
            sut.comments,
            [
                .example(id: 0, depth: 0),
                .example(id: 1, depth: 1, isCollapsed: true),
                .example(id: 3, depth: 1)
            ]
        )
    }
}

// MARK: - Private extension

private extension ItemViewModelTests {

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
