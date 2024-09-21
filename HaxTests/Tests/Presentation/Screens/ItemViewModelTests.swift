//
//  ItemViewModelTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 22/12/22.
//

import Foundation
import Testing
@testable import Hax

@MainActor
struct ItemViewModelTests {

    // MARK: Properties

    private var sut: ItemViewModel
    private let hackerNewsServiceMock: HackerNewsServiceMock
    private let regexServiceMock: RegexServiceMock

    // MARK: Initialization

    init() {
        hackerNewsServiceMock = HackerNewsServiceMock()
        regexServiceMock = RegexServiceMock()
        sut = ItemViewModel(
            item: .example,
            hackerNewsService: hackerNewsServiceMock,
            regexService: regexServiceMock
        )
    }

    // MARK: Tests

    @Test func initialize() {
        #expect(sut.isLoading)
        #expect(sut.error == nil)
        #expect(sut.item == .example)
        #expect(sut.secondaryItem == nil)
        #expect(sut.comments.isEmpty)
        #expect(sut.url == nil)
        #expect(sut.user == nil)
        #expect(sut.highlightedCommentId == nil)
        #expect(sut.title == "98 comments")
    }

    @Test func onViewAppear_givenItemRequestFails() async {
        // When
        await sut.onViewAppear()

        // Then
        #expect(!sut.isLoading)
        #expect(sut.error != nil)
        #expect(sut.item == .example)
        #expect(sut.comments.isEmpty)
        #expect(sut.highlightedCommentId == nil)
        #expect(hackerNewsServiceMock.itemCallCount == 1)
    }

    @Test func onViewAppear_givenItemRequestDoesNotFail() async {
        // Given
        let item = Item(id: 1, comments: [.example])
        hackerNewsServiceMock.itemStub = { _, _ in
            item
        }

        // When
        await sut.onViewAppear()

        // Then
        #expect(!sut.isLoading)
        #expect(sut.error == nil)
        #expect(sut.item == item)
        #expect(sut.comments == [.example])
        #expect(sut.highlightedCommentId == nil)
        #expect(hackerNewsServiceMock.itemCallCount == 1)
    }

    @Test func onViewAppear_whenCalledTwice() async {
        // When
        await sut.onViewAppear()
        await sut.onViewAppear()

        // Then
        #expect(hackerNewsServiceMock.itemCallCount == 1)
    }

    @Test mutating func onViewAppear_givenCommentShouldBeHighlighted() async {
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
        #expect(!sut.isLoading)
        #expect(sut.error == nil)
        #expect(sut.item == storyItem)
        #expect(
            sut.comments ==
            [
                Comment(item: item),
                Comment(item: Item(id: 2), depth: 1)
            ]
        )
        #expect(sut.highlightedCommentId == 1)
        #expect(hackerNewsServiceMock.itemCallCount == 2)
    }

    @Test mutating func onViewAppear_givenShouldFetchItemIsFalse() async {
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
        #expect(!sut.isLoading)
        #expect(sut.error == nil)
        #expect(sut.item == item)
        #expect(sut.comments == item.comments)
        #expect(hackerNewsServiceMock.itemCallCount == .zero)
    }

    @Test func onUserTap() {
        // Given
        let author = "pg"
        let item = Item(author: author)

        // When
        sut.onUserTap(item: item)

        // Then
        #expect(sut.user?.string == author)
    }

    @Test func onCommentTap_givenCommentIsNotInComments() async {
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
        #expect(
            sut.comments ==
            [
                .example,
                .example(id: 1, depth: 1),
                .example(id: 2, depth: 2),
                .example(id: 3, depth: 1)
            ]
        )
    }

    @Test func onCommentTap_givenCommentIsInComments() async {
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
        #expect(
            sut.comments ==
            [
                .example,
                .example(id: 1, depth: 1, isCollapsed: true),
                .example(id: 3, depth: 1)
            ]
        )
    }

    @Test(.bug("https://github.com/lui5fl/hax/issues/62", id: 62))
    func onCommentLinkTap_givenLinkDoesNotContainHackerNewsItemIdentifierAndSchemeDoesNotStartWithHTTP() throws {
        // Given
        let url = try #require(URL(string: "example@example.com"))

        // When
        _ = sut.onCommentLinkTap(url: url)

        // Then
        #expect(sut.secondaryItem == nil)
        #expect(sut.url == nil)
        #expect(regexServiceMock.itemIDCallCount == 1)
    }

    @Test func onCommentLinkTap_givenLinkDoesNotContainHackerNewsItemIdentifierAndSchemeStartsWithHTTP() throws {
        // Given
        let url = try #require(URL(string: "https://luisfl.me"))

        // When
        _ = sut.onCommentLinkTap(url: url)

        // Then
        #expect(sut.secondaryItem == nil)
        #expect(sut.url?.url == url)
        #expect(regexServiceMock.itemIDCallCount == 1)
    }

    @Test func onCommentLinkTap_givenLinkContainsHackerNewsUserIdentifier() throws {
        // Given
        let userID = "pg"
        regexServiceMock.userIDStub = userID
        let url = try #require(
            URL(string: "news.ycombinator.com/user?id=pg")
        )

        // When
        _ = sut.onCommentLinkTap(url: url)

        // Then
        #expect(sut.secondaryItem == nil)
        #expect(sut.url == nil)
        #expect(sut.user?.string == userID)
        #expect(regexServiceMock.itemIDCallCount == 1)
        #expect(regexServiceMock.userIDCallCount == 1)
    }

    @Test func onCommentLinkTap_givenLinkContainsHackerNewsItemIdentifier() throws {
        // Given
        let itemID = 1
        regexServiceMock.itemIDStub = itemID
        let url = try #require(
            URL(string: "news.ycombinator.com/item?id=1")
        )

        // When
        _ = sut.onCommentLinkTap(url: url)

        // Then
        #expect(sut.secondaryItem?.id == itemID)
        #expect(sut.url == nil)
        #expect(sut.user == nil)
        #expect(regexServiceMock.itemIDCallCount == 1)
        #expect(regexServiceMock.userIDCallCount == .zero)
    }

    @Test func onRefreshRequest_givenItemRequestFails() async {
        // Given
        sut.comments = [.example]

        // When
        await sut.onRefreshRequest()

        // Then
        #expect(!sut.isLoading)
        #expect(sut.error != nil)
        #expect(sut.item == .example)
        #expect(sut.comments == [.example])
        #expect(hackerNewsServiceMock.itemCallCount == 1)
    }

    @Test func onRefreshRequest_givenItemRequestDoesNotFail() async {
        // Given
        sut.comments = [.example]
        let item = Item(id: 1, comments: [.example, .example])
        hackerNewsServiceMock.itemStub = { _, _ in
            item
        }

        // When
        await sut.onRefreshRequest()

        // Then
        #expect(!sut.isLoading)
        #expect(sut.error == nil)
        #expect(sut.item == item)
        #expect(sut.comments == [.example, .example])
        #expect(hackerNewsServiceMock.itemCallCount == 1)
    }

    @Test mutating func onRefreshRequest_givenShouldFetchItemIsFalse() async {
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
        #expect(hackerNewsServiceMock.itemCallCount == 1)
    }
}
