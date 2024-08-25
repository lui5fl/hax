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
    private var regexServiceMock: RegexServiceMock!

    // MARK: Set up and tear down

    override func setUpWithError() throws {
        try super.setUpWithError()

        hackerNewsServiceMock = HackerNewsServiceMock()
        regexServiceMock = RegexServiceMock()
        sut = ItemViewModel(
            item: .example,
            hackerNewsService: hackerNewsServiceMock,
            regexService: regexServiceMock
        )
    }

    override func tearDownWithError() throws {
        sut = nil
        hackerNewsServiceMock = nil

        try super.tearDownWithError()
    }

    // MARK: Tests

    func testInit() {
        XCTAssert(sut.isLoading)
        XCTAssertNil(sut.error)
        XCTAssertEqual(sut.item, .example)
        XCTAssertNil(sut.secondaryItem)
        XCTAssertEqual(sut.comments, [])
        XCTAssertNil(sut.url)
        XCTAssertNil(sut.user)
        XCTAssertNil(sut.highlightedCommentId)
        XCTAssertEqual(sut.title, "98 comments")
    }

    func testOnViewAppear_givenItemRequestFails() async {
        // When
        await sut.onViewAppear()

        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertNotNil(sut.error)
        XCTAssertEqual(sut.item, .example)
        XCTAssertEqual(sut.comments, [])
        XCTAssertNil(sut.highlightedCommentId)
        XCTAssertEqual(hackerNewsServiceMock.itemCallCount, 1)
    }

    func testOnViewAppear_givenItemRequestDoesNotFail() async {
        // Given
        let item = Item(id: 1, comments: [.example])
        hackerNewsServiceMock.itemStub = { _, _ in
            item
        }

        // When
        await sut.onViewAppear()

        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
        XCTAssertEqual(sut.item, item)
        XCTAssertEqual(sut.comments, [.example])
        XCTAssertNil(sut.highlightedCommentId)
        XCTAssertEqual(hackerNewsServiceMock.itemCallCount, 1)
    }

    func testOnViewAppear_whenCalledTwice() async {
        // When
        await sut.onViewAppear()
        await sut.onViewAppear()

        // Then
        XCTAssertEqual(hackerNewsServiceMock.itemCallCount, 1)
    }

    func testOnViewAppear_givenCommentShouldBeHighlighted() async {
        // Given
        let item = Item(
            id: 1,
            comments: [Comment(item: Item(id: 2))],
            storyId: .zero
        )
        let storyItem = Item(id: .zero)
        hackerNewsServiceMock.itemStub = { id, _ in
            switch id {
            case .zero:
                storyItem
            case 1:
                item
            default:
                nil
            }
        }
        sut = ItemViewModel(
            item: item,
            hackerNewsService: hackerNewsServiceMock,
            regexService: regexServiceMock
        )

        // When
        await sut.onViewAppear()

        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
        XCTAssertEqual(sut.item, storyItem)
        XCTAssertEqual(
            sut.comments,
            [
                Comment(item: item),
                Comment(item: Item(id: 2), depth: 1)
            ]
        )
        XCTAssertEqual(sut.highlightedCommentId, 1)
        XCTAssertEqual(hackerNewsServiceMock.itemCallCount, 2)
    }

    func testOnViewAppear_givenShouldFetchItemIsFalse() async {
        // Given
        let item = Item(comments: [Comment(item: Item(id: 1))])
        sut = ItemViewModel(
            item: item,
            hackerNewsService: hackerNewsServiceMock,
            regexService: regexServiceMock,
            shouldFetchItem: false
        )

        // When
        await sut.onViewAppear()

        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
        XCTAssertEqual(sut.item, item)
        XCTAssertEqual(sut.comments, item.comments)
        XCTAssertEqual(hackerNewsServiceMock.itemCallCount, .zero)
    }

    func testOnUserTap() {
        // Given
        let author = "pg"
        let item = Item(author: author)

        // When
        sut.onUserTap(item: item)

        // Then
        XCTAssertEqual(sut.user?.string, author)
    }

    func testOnCommentTap_givenCommentIsNotInComments() async {
        // Given
        hackerNewsServiceMock.itemStub = { _, _ in
            Item(
                comments: [
                    .example,
                    .example(id: 1, depth: 1),
                    .example(id: 2, depth: 2),
                    .example(id: 3, depth: 1)
                ]
            )
        }
        await sut.onViewAppear()

        // When
        sut.onCommentTap(comment: .example(id: 4))

        // Then
        XCTAssertEqual(
            sut.comments,
            [
                .example,
                .example(id: 1, depth: 1),
                .example(id: 2, depth: 2),
                .example(id: 3, depth: 1)
            ]
        )
    }

    func testOnCommentTap_givenCommentIsInComments() async {
        // Given
        hackerNewsServiceMock.itemStub = { _, _ in
            Item(
                comments: [
                    .example,
                    .example(id: 1, depth: 1),
                    .example(id: 2, depth: 2),
                    .example(id: 3, depth: 1)
                ]
            )
        }
        await sut.onViewAppear()

        // When
        sut.onCommentTap(comment: .example(id: 1, depth: 1))

        // Then
        XCTAssertEqual(
            sut.comments,
            [
                .example,
                .example(id: 1, depth: 1, isCollapsed: true),
                .example(id: 3, depth: 1)
            ]
        )
    }

    func testOnCommentLinkTap_givenLinkDoesNotContainHackerNewsItemIdentifierAndSchemeDoesNotStartWithHTTP() throws {
        // Given
        let url = try XCTUnwrap(URL(string: "example@example.com"))

        // When
        _ = sut.onCommentLinkTap(url: url)

        // Then
        XCTAssertNil(sut.secondaryItem)
        XCTAssertNil(sut.url)
        XCTAssertEqual(regexServiceMock.itemIDCallCount, 1)
    }

    func testOnCommentLinkTap_givenLinkDoesNotContainHackerNewsItemIdentifierAndSchemeStartsWithHTTP() throws {
        // Given
        let url = try XCTUnwrap(URL(string: "https://luisfl.me"))

        // When
        _ = sut.onCommentLinkTap(url: url)

        // Then
        XCTAssertNil(sut.secondaryItem)
        XCTAssertEqual(sut.url?.url, url)
        XCTAssertEqual(regexServiceMock.itemIDCallCount, 1)
    }

    func testOnCommentLinkTap_givenLinkContainsHackerNewsUserIdentifier() throws {
        // Given
        let userID = "pg"
        regexServiceMock.userIDStub = userID
        let url = try XCTUnwrap(
            URL(string: "news.ycombinator.com/user?id=pg")
        )

        // When
        _ = sut.onCommentLinkTap(url: url)

        // Then
        XCTAssertNil(sut.secondaryItem)
        XCTAssertNil(sut.url)
        XCTAssertEqual(sut.user?.string, userID)
        XCTAssertEqual(regexServiceMock.itemIDCallCount, 1)
        XCTAssertEqual(regexServiceMock.userIDCallCount, 1)
    }

    func testOnCommentLinkTap_givenLinkContainsHackerNewsItemIdentifier() throws {
        // Given
        let itemID = 1
        regexServiceMock.itemIDStub = itemID
        let url = try XCTUnwrap(
            URL(string: "news.ycombinator.com/item?id=1")
        )

        // When
        _ = sut.onCommentLinkTap(url: url)

        // Then
        XCTAssertEqual(sut.secondaryItem?.id, itemID)
        XCTAssertNil(sut.url)
        XCTAssertNil(sut.user)
        XCTAssertEqual(regexServiceMock.itemIDCallCount, 1)
        XCTAssertEqual(regexServiceMock.userIDCallCount, .zero)
    }

    func testOnRefreshRequest_givenItemRequestFails() async {
        // Given
        sut.comments = [.example]

        // When
        await sut.onRefreshRequest()

        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertNotNil(sut.error)
        XCTAssertEqual(sut.item, .example)
        XCTAssertEqual(sut.comments, [.example])
        XCTAssertEqual(hackerNewsServiceMock.itemCallCount, 1)
    }

    func testOnRefreshRequest_givenItemRequestDoesNotFail() async {
        // Given
        sut.comments = [.example]
        let item = Item(id: 1, comments: [.example, .example])
        hackerNewsServiceMock.itemStub = { _, _ in
            item
        }

        // When
        await sut.onRefreshRequest()

        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
        XCTAssertEqual(sut.item, item)
        XCTAssertEqual(sut.comments, [.example, .example])
        XCTAssertEqual(hackerNewsServiceMock.itemCallCount, 1)
    }

    func testOnRefreshRequest_givenShouldFetchItemIsFalse() async {
        // Given
        sut = ItemViewModel(
            item: .example,
            hackerNewsService: hackerNewsServiceMock,
            regexService: regexServiceMock,
            shouldFetchItem: false
        )

        // When
        await sut.onRefreshRequest()

        // Then
        XCTAssertEqual(hackerNewsServiceMock.itemCallCount, 1)
    }
}
