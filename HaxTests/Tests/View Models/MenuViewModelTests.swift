//
//  MenuViewModelTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 20/12/22.
//

import XCTest
@testable import Hax

@MainActor
final class MenuViewModelTests: XCTestCase {

    // MARK: Properties

    private var sut: MenuViewModel!

    // MARK: Set up and tear down

    override func setUpWithError() throws {
        try super.setUpWithError()

        sut = MenuViewModel()
    }

    override func tearDownWithError() throws {
        sut = nil

        try super.tearDownWithError()
    }

    // MARK: Tests

    func testInit() {
        XCTAssertEqual(sut.feeds, Feed.allCases)
    }
}
