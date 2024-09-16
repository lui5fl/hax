//
//  FirebaseUserDTOTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 30/5/24.
//

import Testing
@testable import Hax

struct FirebaseUserDTOTests {

    // MARK: Tests

    @Test func initializeFromDecoder_givenNoNilPropertiesJSON() throws {
        // Given
        let jsonResourceName = "FirebaseUserDTO_NoNilProperties"

        // When
        let sut = try JSONHelper.firebaseUserDTO(
            jsonResourceName: jsonResourceName
        )

        // Then
        #expect(sut.about == "Bug fixer.")
        #expect(sut.created == 1160418092)
        #expect(sut.id == "pg")
        #expect(sut.karma == 157236)
        #expect(sut.submitted?.count == 1)
    }

    @Test func initializeFromDecoder_givenSomeNilPropertiesJSON() throws {
        // Given
        let jsonResourceName = "FirebaseUserDTO_SomeNilProperties"

        // When
        let sut = try JSONHelper.firebaseUserDTO(
            jsonResourceName: jsonResourceName
        )

        // Then
        #expect(sut.about == nil)
        #expect(sut.created == 1160418092)
        #expect(sut.id == "pg")
        #expect(sut.karma == 157236)
        #expect(sut.submitted == nil)
    }
}
