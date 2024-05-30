//
//  CommentRowViewModelTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 22/12/22.
//

import XCTest
@testable import Hax

final class CommentRowViewModelTests: XCTestCase {

    // MARK: Tests

    func testInit() throws {
        // Given
        var onUserTapCallCount = Int.zero
        var onLinkTapCallCount = Int.zero
        let url = try XCTUnwrap(URL(string: "luisfl.me"))

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
        XCTAssertEqual(sut.comment, .example)
        XCTAssertEqual(onUserTapCallCount, 1)
        XCTAssertEqual(onLinkTapCallCount, 1)
        XCTAssertFalse(sut.shouldHighlightAuthor)
    }

    func testShouldHighlightAuthor_givenCommentAuthorIsEqualToItemAuthor() {
        // Given
        let author = "example"
        let comment = Comment(item: Item(author: author))
        let item = Item(author: author)
        let sut = CommentRowViewModel(comment: comment, item: item)

        // When
        let shouldHighlightAuthor = sut.shouldHighlightAuthor

        // Then
        XCTAssert(shouldHighlightAuthor)
    }
}
