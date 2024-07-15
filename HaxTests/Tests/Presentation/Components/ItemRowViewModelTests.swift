//
//  ItemRowViewModelTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 22/12/22.
//

import XCTest
@testable import Hax

final class ItemRowViewModelTests: XCTestCase {

    // MARK: Properties

    private static var suts: [ItemRowViewModel]! = []

    // MARK: Set up and tear down

    override static func setUp() {
        super.setUp()

        for view in ItemRowViewModelView.allCases {
            for kind in Item.Kind.allCases {
                suts.append(
                    ItemRowViewModel(
                        in: view,
                        item: Item(kind: kind)
                    )
                )
            }
        }
    }

    override static func tearDown() {
        suts = nil

        super.tearDown()
    }

    // MARK: Tests

    func testInit() throws {
        // Given
        let item = Item(kind: .story)
        var onUserTapCallCount = Int.zero
        var onNumberOfCommentsTapCallCount = Int.zero
        var onLinkTapCallCount = Int.zero
        let url = try XCTUnwrap(URL(string: "luisfl.me"))

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
        XCTAssertEqual(sut.view, .feed)
        XCTAssertEqual(sut.index, 9)
        XCTAssertEqual(sut.item, item)
        XCTAssert(sut.shouldDisplayIndex)
        XCTAssertFalse(sut.shouldDisplayBody)
        XCTAssertFalse(sut.shouldDisplayAuthor)
        XCTAssert(sut.shouldDisplayScore)
        XCTAssert(sut.shouldDisplayNumberOfComments)
        XCTAssertEqual(onUserTapCallCount, 1)
        XCTAssertEqual(onNumberOfCommentsTapCallCount, 1)
        XCTAssertEqual(onLinkTapCallCount, 1)
    }

    func testShouldDisplayIndex() {
        for sut in Self.suts {
            // When
            let shouldDisplayIndex = sut.shouldDisplayIndex

            // Then
            XCTAssertEqual(shouldDisplayIndex, sut.view == .feed)
        }
    }

    func testShouldDisplayBody() {
        for sut in Self.suts {
            // When
            let shouldDisplayBody = sut.shouldDisplayBody

            // Then
            XCTAssertEqual(shouldDisplayBody, sut.view == .item)
        }
    }

    func testShouldDisplayBody_givenCommentIsHighlighted() {
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
        XCTAssertFalse(shouldDisplayBody)
    }

    func testShouldDisplayAuthor() {
        for sut in Self.suts {
            // When
            let shouldDisplayAuthor = sut.shouldDisplayAuthor

            // Then
            XCTAssertEqual(shouldDisplayAuthor, sut.view == .item)
        }
    }

    func testShouldDisplayScore() {
        for sut in Self.suts {
            // When
            let shouldDisplayScore = sut.shouldDisplayScore

            // Then
            XCTAssertEqual(shouldDisplayScore, sut.item.kind != .job)
        }
    }

    func testShouldDisplayNumberOfComments() {
        for sut in Self.suts {
            // When
            let shouldDisplayNumberOfComments = sut.shouldDisplayNumberOfComments

            // Then
            XCTAssertEqual(
                shouldDisplayNumberOfComments,
                sut.view == .feed && sut.item.kind != .job
            )
        }
    }
}
