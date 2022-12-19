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
            comment: .example,
            onLinkTap: { _ in
                onLinkTapCallCount += 1
            }
        )
        sut.onLinkTap?(url)

        // Then
        XCTAssertEqual(sut.comment, .example)
        XCTAssertEqual(onLinkTapCallCount, 1)
    }
}
