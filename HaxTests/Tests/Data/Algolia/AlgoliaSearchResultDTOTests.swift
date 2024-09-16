//
//  AlgoliaSearchResultDTOTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 28/8/24.
//

import Testing
@testable import Hax

struct AlgoliaSearchResultDTOTests {

    // MARK: Tests

    @Test func initializeFromDecoder_givenNoNilPropertiesJSON() throws {
        // Given
        let jsonResourceName = "AlgoliaSearchResultDTO_NoNilProperties"

        // When
        let sut = try JSONHelper.algoliaSearchResultDTO(
            jsonResourceName: jsonResourceName
        )

        // Then
        #expect(sut.author == "pg")
        #expect(sut.children?.count == 4)
        #expect(sut.createdAt == "2006-10-09T18:21:51Z")
        #expect(sut.createdAtI == 1160418111)
        #expect(sut.numComments == 15)
        #expect(sut.objectID == "1")
        #expect(sut.points == 57)
        #expect(sut.storyId == 1)
        #expect(sut.title == "Y Combinator")
        #expect(sut.updatedAt == "2024-07-31T18:34:19Z")
        #expect(sut.url == "http://ycombinator.com")
    }

    @Test func initializeFromDecoder_givenSomeNilPropertiesJSON() throws {
        // Given
        let jsonResourceName = "AlgoliaSearchResultDTO_SomeNilProperties"

        // When
        let sut = try JSONHelper.algoliaSearchResultDTO(
            jsonResourceName: jsonResourceName
        )

        // Then
        #expect(sut.author == nil)
        #expect(sut.children == nil)
        #expect(sut.createdAt == "2006-10-09T18:21:51Z")
        #expect(sut.createdAtI == 1160418111)
        #expect(sut.numComments == nil)
        #expect(sut.objectID == "1")
        #expect(sut.points == nil)
        #expect(sut.storyId == nil)
        #expect(sut.title == nil)
        #expect(sut.updatedAt == "2024-07-31T18:34:19Z")
        #expect(sut.url == nil)
    }
}
