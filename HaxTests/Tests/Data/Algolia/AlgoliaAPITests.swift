//
//  AlgoliaAPITests.swift
//  HaxTests
//
//  Created by Luis Fariña on 12/5/24.
//

import Testing
@testable import Hax

struct AlgoliaAPITests {

    // MARK: Properties

    private let sut = AlgoliaAPI()

    // MARK: Tests

    @Test func initialize() {
        #expect(sut.scheme == "https")
        #expect(sut.host == "hn.algolia.com")
    }
}
