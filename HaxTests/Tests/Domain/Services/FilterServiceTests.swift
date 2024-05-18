//
//  FilterServiceTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 16/4/24.
//

import SwiftData
import XCTest
@testable import Hax

@MainActor
final class FilterServiceTests: XCTestCase {

    // MARK: Properties

    private var sut: FilterService!

    // MARK: Set up and tear down

    override func setUpWithError() throws {
        try super.setUpWithError()

        let modelConfiguration = ModelConfiguration(isStoredInMemoryOnly: true)
        let modelContainer = try ModelContainer(
            for: KeywordFilter.self,
            UserFilter.self,
            configurations: modelConfiguration
        )
        let modelContext = modelContainer.mainContext
        modelContext.insert(KeywordFilter(keyword: "keyword"))
        modelContext.insert(UserFilter(user: "author"))
        sut = FilterService(modelContext: modelContext)
    }

    override func tearDownWithError() throws {
        sut = nil

        try super.tearDownWithError()
    }

    // MARK: Tests

    func testFilteredItems_givenItemWhichIsDeleted() {
        // Given
        let item = Item(deleted: true)

        // When
        let filteredItems = sut.filtered(items: [item])

        // Then
        XCTAssert(filteredItems.isEmpty)
    }

    func testFilteredItems_givenItemWhichIsDead() {
        // Given
        let item = Item(dead: true)

        // When
        let filteredItems = sut.filtered(items: [item])

        // Then
        XCTAssert(filteredItems.isEmpty)
    }

    func testFilteredItems_givenItemWhoseBodyHasFilteredKeyword() {
        // Given
        let item = Item(body: "keyword")

        // When
        let filteredItems = sut.filtered(items: [item])

        // Then
        XCTAssert(filteredItems.isEmpty)
    }

    func testFilteredItems_givenItemWhoseURLHasFilteredKeyword() {
        // Given
        let item = Item(url: URL(string: "https://luisfl.me/keyword"))

        // When
        let filteredItems = sut.filtered(items: [item])

        // Then
        XCTAssert(filteredItems.isEmpty)
    }

    func testFilteredItems_givenItemWhoseTitleHasFilteredKeyword() {
        // Given
        let item = Item(title: "keyword")

        // When
        let filteredItems = sut.filtered(items: [item])

        // Then
        XCTAssert(filteredItems.isEmpty)
    }

    func testFilteredItems_givenItemWhoseAuthorIsFiltered() {
        // Given
        let item = Item(author: "author")

        // When
        let filteredItems = sut.filtered(items: [item])

        // Then
        XCTAssert(filteredItems.isEmpty)
    }

    func testFilteredItems_givenItemWithoutFilteredKeywordsAndWhoseAuthorIsNotFiltered() {
        // Given
        let item = Item()

        // When
        let filteredItems = sut.filtered(items: [item])

        // Then
        XCTAssertEqual(filteredItems, [item])
    }
}
