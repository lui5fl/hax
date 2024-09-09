//
//  SearchViewModelTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 9/9/24.
//

import XCTest
@testable import Hax

@MainActor
final class SearchViewModelTests: XCTestCase {

    // MARK: Properties

    private var sut: SearchViewModel!
    private var hackerNewsServiceMock: HackerNewsServiceMock!

    // MARK: Set up and tear down

    override func setUp() {
        super.setUp()

        hackerNewsServiceMock = HackerNewsServiceMock()
        sut = SearchViewModel(
            hackerNewsService: hackerNewsServiceMock
        )
    }

    override func tearDown() {
        sut = nil
        hackerNewsServiceMock = nil

        super.tearDown()
    }

    // MARK: Tests

    func testInit() {
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
        XCTAssert(sut.items.isEmpty)
        XCTAssertEqual(sut.text, "")
    }

    func testOnSubmit_givenSearchRequestFails() async {
        // When
        await sut.onSubmit()

        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertNotNil(sut.error)
        XCTAssert(sut.items.isEmpty)
        XCTAssertEqual(sut.text, "")
        XCTAssertEqual(hackerNewsServiceMock.searchCallCount, 1)
    }

    func testOnSubmit_givenSearchRequestDoesNotFail() async {
        // Given
        let items = [Item.example]
        hackerNewsServiceMock.searchStub = { _ in
            items
        }

        // When
        await sut.onSubmit()

        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
        XCTAssertEqual(sut.items, items)
        XCTAssertEqual(sut.text, "")
        XCTAssertEqual(hackerNewsServiceMock.searchCallCount, 1)
    }
}
