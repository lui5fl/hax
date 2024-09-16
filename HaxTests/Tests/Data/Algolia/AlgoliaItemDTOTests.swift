//
//  AlgoliaItemDTOTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 11/5/24.
//

import Testing
@testable import Hax

struct AlgoliaItemDTOTests {

    // MARK: Tests

    @Test func initializeFromDecoder_givenNoNilPropertiesJSON() throws {
        // Given
        let jsonResourceName = "AlgoliaItemDTO_NoNilProperties"

        // When
        let sut = try JSONHelper.algoliaItemDTO(
            jsonResourceName: jsonResourceName
        )

        // Then
        #expect(sut.author == "pg")
        #expect(sut.children.count == 1)
        #expect(sut.createdAt == "2006-10-09T18:21:51.000Z")
        #expect(sut.createdAtI == 1160418111)
        #expect(sut.id == 1)
        #expect(sut.options.count == 1)
        #expect(sut.parentId == 42)
        #expect(sut.points == 57)
        #expect(sut.storyId == 1)
        #expect(sut.text == "text")
        #expect(sut.title == "Y Combinator")
        #expect(sut.type == "story")
        #expect(sut.url == "http://ycombinator.com")
    }

    @Test func initializeFromDecoder_givenSomeNilPropertiesJSON() throws {
        // Given
        let jsonResourceName = "AlgoliaItemDTO_SomeNilProperties"

        // When
        let sut = try JSONHelper.algoliaItemDTO(
            jsonResourceName: jsonResourceName
        )

        // Then
        #expect(sut.author == "pg")
        #expect(sut.children.isEmpty)
        #expect(sut.createdAt == "2006-10-09T18:21:51.000Z")
        #expect(sut.createdAtI == 1160418111)
        #expect(sut.id == 1)
        #expect(sut.options.isEmpty)
        #expect(sut.parentId == nil)
        #expect(sut.points == nil)
        #expect(sut.storyId == nil)
        #expect(sut.text == nil)
        #expect(sut.title == nil)
        #expect(sut.type == "story")
        #expect(sut.url == nil)
    }
}
