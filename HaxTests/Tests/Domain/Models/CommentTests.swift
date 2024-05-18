//
//  CommentTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 21/12/22.
//

import XCTest
@testable import Hax

final class CommentTests: XCTestCase {

    // MARK: Properties

    private var sut: Comment!

    // MARK: Set up and tear down

    override func setUpWithError() throws {
        try super.setUpWithError()

        sut = Comment(item: .example, depth: 0)
    }

    override func tearDownWithError() throws {
        sut = nil

        try super.tearDownWithError()
    }

    // MARK: Tests

    func testInit() {
        XCTAssertEqual(sut.item, .example)
        XCTAssertEqual(sut.depth, 0)
        XCTAssertFalse(sut.isCollapsed)
        XCTAssertFalse(sut.isHidden)
    }

    func testEqualToOperator() {
        // Given
        let equalComment = Comment(item: .example, depth: 0)

        // When
        let equal = sut == equalComment

        // Then
        XCTAssert(equal)
    }

    func testId() {
        // When
        let id = sut.id

        // Then
        XCTAssertEqual(id, sut.item.id)
    }
}
