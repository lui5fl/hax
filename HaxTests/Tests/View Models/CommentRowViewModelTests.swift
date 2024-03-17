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
        var onLinkTapCallCount = 0
        let url = try XCTUnwrap(URL(string: "luisfl.me"))

        // When
        let sut = CommentRowViewModel(
            comment: Comment(item: Item(author: "1")),
            item: Item(author: "2")
        ) { _ in
            onLinkTapCallCount += 1
        }
        sut.onLinkTap?(url)

        // Then
        XCTAssertEqual(sut.comment, .example)
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
