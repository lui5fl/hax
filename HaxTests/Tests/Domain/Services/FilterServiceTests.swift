//
//  FilterServiceTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 16/4/24.
//

import Foundation
import SwiftData
import Testing
@testable import Hax

struct FilterServiceTests {

    // MARK: Properties

    private let sut: FilterService

    // MARK: Initialization

    @MainActor
    init() throws {
        let modelConfiguration = ModelConfiguration(
            isStoredInMemoryOnly: true
        )
        let modelContainer = try ModelContainer(
            for: KeywordFilter.self,
            UserFilter.self,
            configurations: modelConfiguration
        )
        let modelContext = modelContainer.mainContext
        modelContext.insert(KeywordFilter(keyword: "keyword"))
        modelContext.insert(UserFilter(user: "author"))
        try modelContext.save()
        sut = FilterService(modelContainer: modelContainer)
    }

    // MARK: Tests

    @Test func filteredItems_givenItemWhichIsDeleted() async {
        // Given
        let item = Item(deleted: true)

        // When
        let filteredItems = await sut.filtered(items: [item])

        // Then
        #expect(filteredItems.isEmpty)
    }

    @Test func filteredItems_givenItemWhichIsDead() async {
        // Given
        let item = Item(dead: true)

        // When
        let filteredItems = await sut.filtered(items: [item])

        // Then
        #expect(filteredItems.isEmpty)
    }

    @Test func filteredItems_givenItemWhoseBodyHasFilteredKeyword() async {
        // Given
        let item = Item(body: "keyword")

        // When
        let filteredItems = await sut.filtered(items: [item])

        // Then
        #expect(filteredItems.isEmpty)
    }

    @Test func filteredItems_givenItemWhoseURLHasFilteredKeyword() async {
        // Given
        let item = Item(
            url: URL(string: "https://luisfl.me/keyword")
        )

        // When
        let filteredItems = await sut.filtered(items: [item])

        // Then
        #expect(filteredItems.isEmpty)
    }

    @Test func filteredItems_givenItemWhoseTitleHasFilteredKeyword() async {
        // Given
        let item = Item(title: "keyword")

        // When
        let filteredItems = await sut.filtered(items: [item])

        // Then
        #expect(filteredItems.isEmpty)
    }

    @Test func filteredItems_givenItemWhoseAuthorIsFiltered() async {
        // Given
        let item = Item(author: "author")

        // When
        let filteredItems = await sut.filtered(items: [item])

        // Then
        #expect(filteredItems.isEmpty)
    }

    @Test func filteredItems_givenItemWithoutFilteredKeywordsAndWhoseAuthorIsNotFiltered() async {
        // Given
        let item = Item()

        // When
        let filteredItems = await sut.filtered(items: [item])

        // Then
        #expect(filteredItems == [item])
    }
}
