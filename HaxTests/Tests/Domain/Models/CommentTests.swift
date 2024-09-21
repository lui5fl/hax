//
//  CommentTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 21/12/22.
//

import Testing
@testable import Hax

struct CommentTests {

    // MARK: Properties

    private let sut = Comment(item: .example)

    // MARK: Tests

    @Test func initialize() {
        #expect(sut.item == .example)
        #expect(sut.depth == .zero)
        #expect(!sut.isCollapsed)
        #expect(!sut.isHidden)
    }

    @Test func equalToOperator() {
        // Given
        let equalComment = Comment(item: .example)

        // When
        let equal = sut == equalComment

        // Then
        #expect(equal)
    }

    @Test func id() {
        // When
        let id = sut.id

        // Then
        #expect(id == sut.item.id)
    }
}
