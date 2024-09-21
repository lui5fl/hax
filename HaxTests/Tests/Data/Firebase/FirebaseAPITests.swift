//
//  FirebaseAPITests.swift
//  HaxTests
//
//  Created by Luis Fariña on 12/5/24.
//

import Testing
@testable import Hax

struct FirebaseAPITests {

    // MARK: Properties

    private let sut = FirebaseAPI()

    // MARK: Tests

    @Test func initialize() {
        #expect(sut.scheme == "https")
        #expect(sut.host == "hacker-news.firebaseio.com")
    }
}
