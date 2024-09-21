//
//  CommentRowViewModelTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 22/12/22.
//

import Foundation
import Testing
@testable import Hax

struct CommentRowViewModelTests {

    // MARK: Tests

    @Test func initialize() throws {
        // Given
        var onUserTapCallCount = Int.zero
        var onLinkTapCallCount = Int.zero
        let url = try #require(URL(string: "luisfl.me"))

        // When
        let sut = CommentRowViewModel(
            comment: Comment(item: Item(author: "1")),
            item: Item(author: "2"),
            onUserTap: {
                onUserTapCallCount += 1
            },
            onLinkTap: { _ in
                onLinkTapCallCount += 1

                return .handled
            }
        )
        sut.onUserTap?()
        _ = sut.onLinkTap?(url)

        // Then
        #expect(sut.comment == .example)
        #expect(onUserTapCallCount == 1)
        #expect(onLinkTapCallCount == 1)
        #expect(!sut.shouldHighlightAuthor)
    }

    @Test func shouldHighlightAuthor_givenCommentAuthorIsEqualToItemAuthor() {
        // Given
        let author = "example"
        let comment = Comment(item: Item(author: author))
        let item = Item(author: author)
        let sut = CommentRowViewModel(comment: comment, item: item)

        // When
        let shouldHighlightAuthor = sut.shouldHighlightAuthor

        // Then
        #expect(shouldHighlightAuthor)
    }
}
