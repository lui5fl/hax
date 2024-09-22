//
//  ItemTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 21/12/22.
//

import Foundation
import Testing
@testable import Hax

struct ItemTests {

    // MARK: Tests

    @Test func initialize_givenAlgoliaItemDTO() throws {
        // Given
        let algoliaItemDTO = try algoliaItemDTO()

        // When
        let sut = Item(algoliaItemDTO: algoliaItemDTO)

        // Then
        #expect(sut.id == 1)
        #expect(!sut.deleted)
        #expect(sut.kind == .story)
        #expect(sut.author == "pg")
        #expect(sut.body == "text")
        #expect(!sut.dead)
        #expect(sut.children.count == 1)
        #expect(
            sut.url ==
            URL(string: "http://ycombinator.com")
        )
        #expect(sut.score == 57)
        #expect(sut.title == "Y Combinator")
        #expect(sut.descendants == nil)
        #expect(sut.comments.isEmpty)
        #expect(sut.storyId == 1)
        #expect(sut.markdownBody != nil)
        #expect(sut.urlSimpleString != nil)
        #expect(sut.elapsedTimeString != nil)
        #expect(
            sut.hackerNewsURL ==
            URL(string: "https://news.ycombinator.com/item?id=1")
        )
    }

    @Test func initialize_givenAlgoliaSearchResultDTO() throws {
        // Given
        let algoliaSearchResultDTO = try JSONHelper.algoliaSearchResultDTO(
            jsonResourceName: "AlgoliaSearchResultDTO_NoNilProperties"
        )

        // When
        let sut = Item(
            algoliaSearchResultDTO: algoliaSearchResultDTO
        )

        // Then
        #expect(sut.id == 1)
        #expect(!sut.deleted)
        #expect(sut.kind == nil)
        #expect(sut.author == "pg")
        #expect(sut.body == nil)
        #expect(!sut.dead)
        #expect(sut.children.isEmpty)
        #expect(
            sut.url ==
            URL(string: "http://ycombinator.com")
        )
        #expect(sut.score == 57)
        #expect(sut.title == "Y Combinator")
        #expect(sut.descendants == 15)
        #expect(sut.comments.isEmpty)
        #expect(sut.storyId == 1)
        #expect(sut.markdownBody == nil)
        #expect(sut.urlSimpleString != nil)
        #expect(sut.elapsedTimeString != nil)
        #expect(
            sut.hackerNewsURL ==
            URL(string: "https://news.ycombinator.com/item?id=1")
        )
    }

    @Test func initialize_givenFirebaseItemDTO() throws {
        // Given
        let firebaseItemDTO = try firebaseItemDTO()

        // When
        let sut = Item(firebaseItemDTO: firebaseItemDTO)

        // Then
        #expect(sut.id == 1)
        #expect(!sut.deleted)
        #expect(sut.kind == .story)
        #expect(sut.author == "pg")
        #expect(sut.body == "text")
        #expect(!sut.dead)
        #expect(sut.children.isEmpty)
        #expect(
            sut.url ==
            URL(string: "http://ycombinator.com")
        )
        #expect(sut.score == 57)
        #expect(sut.title == "Y Combinator")
        #expect(sut.descendants == 15)
        #expect(sut.comments.isEmpty)
        #expect(sut.storyId == nil)
        #expect(sut.markdownBody != nil)
        #expect(sut.urlSimpleString != nil)
        #expect(sut.elapsedTimeString != nil)
        #expect(
            sut.hackerNewsURL ==
            URL(string: "https://news.ycombinator.com/item?id=1")
        )
    }

    @Test func initialize_givenAlgoliaAndFirebaseItemDTOs() async throws {
        // Given
        let algoliaItemDTO = try algoliaItemDTO()
        let firebaseItemDTO = try firebaseItemDTO()
        let filterServiceMock = FilterServiceMock()

        // When
        let sut = await Item(
            algoliaItemDTO: algoliaItemDTO,
            firebaseItemDTO: firebaseItemDTO,
            filterService: filterServiceMock
        )

        // Then
        #expect(sut.id == 1)
        #expect(!sut.deleted)
        #expect(sut.kind == .story)
        #expect(sut.author == "pg")
        #expect(sut.body == "text")
        #expect(!sut.dead)
        #expect(sut.children.isEmpty)
        #expect(
            sut.url ==
            URL(string: "http://ycombinator.com")
        )
        #expect(sut.score == 57)
        #expect(sut.title == "Y Combinator")
        #expect(sut.descendants == 15)
        #expect(sut.comments.count == 1)
        #expect(sut.storyId == 1)
        #expect(sut.markdownBody != nil)
        #expect(sut.urlSimpleString != nil)
        #expect(sut.elapsedTimeString != nil)
        #expect(
            sut.hackerNewsURL ==
            URL(string: "https://news.ycombinator.com/item?id=1")
        )
        #expect(await filterServiceMock.filteredItemsCallCount == 2)
    }
}

// MARK: - Private extension

private extension ItemTests {

    // MARK: Methods

    func algoliaItemDTO() throws -> AlgoliaItemDTO {
        try JSONHelper.algoliaItemDTO(
            jsonResourceName: "AlgoliaItemDTO_NoNilProperties"
        )
    }

    func firebaseItemDTO() throws -> FirebaseItemDTO {
        try JSONHelper.firebaseItemDTO(
            jsonResourceName: "FirebaseItemDTO_NoNilProperties"
        )
    }
}
