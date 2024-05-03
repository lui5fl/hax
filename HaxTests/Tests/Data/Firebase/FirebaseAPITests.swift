//
//  FirebaseAPITests.swift
//  HaxTests
//
//  Created by Luis Fariña on 12/5/24.
//

import XCTest
@testable import Hax

final class FirebaseAPITests: XCTestCase {

    // MARK: Properties

    private var sut: FirebaseAPI!

    // MARK: Set up and tear down

    override func setUp() {
        super.setUp()

        sut = FirebaseAPI()
    }

    override func tearDown() {
        sut = nil

        super.tearDown()
    }

    // MARK: Tests

    func testInit() {
        XCTAssertEqual(sut.scheme, "https")
        XCTAssertEqual(sut.host, "hacker-news.firebaseio.com")
    }
}
