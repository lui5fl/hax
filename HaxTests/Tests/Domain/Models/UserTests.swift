//
//  UserTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 31/5/24.
//

import Foundation
import Testing
@testable import Hax

struct UserTests {

    // MARK: Tests

    @Test func initialize_givenFirebaseUserDTO() throws {
        // Given
        let firebaseUserDTO = try JSONHelper.firebaseUserDTO(
            jsonResourceName: "FirebaseUserDTO_NoNilProperties"
        )

        // When
        let sut = User(firebaseUserDTO: firebaseUserDTO)

        // Then
        #expect(sut.id == "pg")
        #expect(
            sut.creationDate ==
            Date(timeIntervalSince1970: 1160418092)
        )
        #expect(sut.karma == 157236)
        #expect(sut.description == "Bug fixer.")
        #expect(
            sut.url ==
            URL(string: "https://news.ycombinator.com/user?id=pg")
        )
    }
}
