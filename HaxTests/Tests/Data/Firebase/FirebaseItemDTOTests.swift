//
//  FirebaseItemDTOTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 12/5/24.
//

import Testing
@testable import Hax

struct FirebaseItemDTOTests {

    // MARK: Tests

    @Test func initializeFromDecoder_givenNoNilPropertiesJSON() throws {
        // Given
        let jsonResourceName = "FirebaseItemDTO_NoNilProperties"

        // When
        let sut = try JSONHelper.firebaseItemDTO(
            jsonResourceName: jsonResourceName
        )

        // Then
        #expect(sut.by == "pg")
        #expect(sut.dead == false)
        #expect(sut.deleted == false)
        #expect(sut.descendants == 15)
        #expect(sut.id == 1)
        #expect(sut.kids?.count == 4)
        #expect(sut.parent == 42)
        #expect(sut.parts?.count == 1)
        #expect(sut.poll == 42)
        #expect(sut.score == 57)
        #expect(sut.text == "text")
        #expect(sut.time == 1160418111)
        #expect(sut.title == "Y Combinator")
        #expect(sut.type == "story")
        #expect(sut.url == "http://ycombinator.com")
    }

    @Test func initializeFromDecoder_givenSomeNilPropertiesJSON() throws {
        // Given
        let jsonResourceName = "FirebaseItemDTO_SomeNilProperties"

        // When
        let sut = try JSONHelper.firebaseItemDTO(
            jsonResourceName: jsonResourceName
        )

        // Then
        #expect(sut.by == nil)
        #expect(sut.dead == nil)
        #expect(sut.deleted == nil)
        #expect(sut.descendants == nil)
        #expect(sut.id == 42)
        #expect(sut.kids == nil)
        #expect(sut.parent == nil)
        #expect(sut.parts == nil)
        #expect(sut.poll == nil)
        #expect(sut.score == nil)
        #expect(sut.text == nil)
        #expect(sut.time == nil)
        #expect(sut.title == nil)
        #expect(sut.type == nil)
        #expect(sut.url == nil)
    }
}
