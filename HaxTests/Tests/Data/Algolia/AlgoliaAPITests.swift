//
//  AlgoliaAPITests.swift
//  HaxTests
//
//  Created by Luis Fariña on 12/5/24.
//

import XCTest
@testable import Hax

final class AlgoliaAPITests: XCTestCase {

    // MARK: Properties

    private var sut: AlgoliaAPI!

    // MARK: Set up and tear down

    override func setUp() {
        super.setUp()

        sut = AlgoliaAPI()
    }

    override func tearDown() {
        sut = nil

        super.tearDown()
    }

    // MARK: Tests

    func testInit() {
        XCTAssertEqual(sut.scheme, "https")
        XCTAssertEqual(sut.host, "hn.algolia.com")
    }
}
