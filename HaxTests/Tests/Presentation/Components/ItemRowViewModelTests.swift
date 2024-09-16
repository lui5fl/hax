//
//  ItemRowViewModelTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 22/12/22.
//

import Foundation
import Testing
@testable import Hax

struct ItemRowViewModelTests {

    // MARK: Tests

    @Test func initialize() throws {
        // Given
        let item = Item(kind: .story)
        var onUserTapCallCount = Int.zero
        var onNumberOfCommentsTapCallCount = Int.zero
        var onLinkTapCallCount = Int.zero
        let url = try #require(URL(string: "luisfl.me"))

        // When
        let sut = ItemRowViewModel(
            in: .feed,
            index: 9,
            item: item,
            onUserTap: {
                onUserTapCallCount += 1
            },
            onNumberOfCommentsTap: {
                onNumberOfCommentsTapCallCount += 1
            },
            onLinkTap: { _ in
                onLinkTapCallCount += 1

                return .handled
            }
        )
        sut.onUserTap?()
        sut.onNumberOfCommentsTap?()
        _ = sut.onLinkTap?(url)

        // Then
        #expect(sut.view == .feed)
        #expect(sut.index == 9)
        #expect(sut.item == item)
        #expect(sut.shouldDisplayIndex)
        #expect(!sut.shouldDisplayBody)
        #expect(!sut.shouldDisplayAuthor)
        #expect(sut.shouldDisplayScore)
        #expect(sut.shouldDisplayNumberOfComments)
        #expect(onUserTapCallCount == 1)
        #expect(onNumberOfCommentsTapCallCount == 1)
        #expect(onLinkTapCallCount == 1)
    }

    @Test(
        arguments: Item.Kind.allCases,
        ItemRowViewModelView.allCases
    )
    func shouldDisplayIndex(
        of kind: Item.Kind,
        in view: ItemRowViewModelView
    ) {
        // Given
        let sut = sut(kind: kind, view: view)

        // When
        let shouldDisplayIndex = sut.shouldDisplayIndex

        // Then
        #expect(shouldDisplayIndex == (view == .feed))
    }

    @Test(
        arguments: Item.Kind.allCases,
        ItemRowViewModelView.allCases
    )
    func shouldDisplayBody(
        of kind: Item.Kind,
        in view: ItemRowViewModelView
    ) {
        // Given
        let sut = sut(kind: kind, view: view)

        // When
        let shouldDisplayBody = sut.shouldDisplayBody

        // Then
        #expect(shouldDisplayBody == (view == .item))
    }

    @Test func shouldDisplayBody_givenCommentIsHighlighted() {
        // Given
        let commentIsHighlighted = true
        let sut = ItemRowViewModel(
            in: .item,
            item: .example,
            commentIsHighlighted: commentIsHighlighted
        )

        // When
        let shouldDisplayBody = sut.shouldDisplayBody

        // Then
        #expect(!shouldDisplayBody)
    }

    @Test(.bug("https://github.com/lui5fl/hax/issues/98", id: 98))
    func shouldDisplayBody_givenBodyIsEmptyString() {
        // Given
        let body = ""
        let sut = ItemRowViewModel(in: .item, item: Item(body: body))

        // When
        let shouldDisplayBody = sut.shouldDisplayBody

        // Then
        #expect(!shouldDisplayBody)
    }

    @Test(
        arguments: Item.Kind.allCases,
        ItemRowViewModelView.allCases
    )
    func shouldDisplayAuthor(
        of kind: Item.Kind,
        in view: ItemRowViewModelView
    ) {
        // Given
        let sut = sut(kind: kind, view: view)

        // When
        let shouldDisplayAuthor = sut.shouldDisplayAuthor

        // Then
        #expect(shouldDisplayAuthor == (view == .item))
    }

    @Test(
        arguments: Item.Kind.allCases,
        ItemRowViewModelView.allCases
    )
    func shouldDisplayScore(
        of kind: Item.Kind,
        in view: ItemRowViewModelView
    ) {
        // Given
        let sut = sut(kind: kind, view: view)

        // When
        let shouldDisplayScore = sut.shouldDisplayScore

        // Then
        #expect(shouldDisplayScore == (kind != .job))
    }

    @Test(
        arguments: Item.Kind.allCases,
        ItemRowViewModelView.allCases
    )
    func shouldDisplayNumberOfComments(
        of kind: Item.Kind,
        in view: ItemRowViewModelView
    ) {
        // Given
        let sut = sut(kind: kind, view: view)

        // When
        let shouldDisplayNumberOfComments = sut.shouldDisplayNumberOfComments

        // Then
        #expect(
            shouldDisplayNumberOfComments ==
            (view == .feed && kind != .job)
        )
    }
}

// MARK: - Private extension

private extension ItemRowViewModelTests {

    // MARK: Methods

    func sut(
        kind: Item.Kind,
        view: ItemRowViewModelView
    ) -> ItemRowViewModel {
        ItemRowViewModel(
            in: view,
            item: Item(kind: kind, body: "Body")
        )
    }
}
