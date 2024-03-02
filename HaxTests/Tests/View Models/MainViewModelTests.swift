//
//  MainViewModelTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 2/3/24.
//

import XCTest
@testable import Hax

@MainActor
final class MainViewModelTests: XCTestCase {

    // MARK: Properties

    private var sut: MainViewModel!
    private var defaultFeedServiceMock: DefaultFeedServiceMock!

    // MARK: Set up and tear down

    override func setUpWithError() throws {
        try super.setUpWithError()

        defaultFeedServiceMock = DefaultFeedServiceMock()
        defaultFeedServiceMock.defaultFeedStub = .best
        sut = MainViewModel(defaultFeedService: defaultFeedServiceMock)
    }

    override func tearDownWithError() throws {
        sut = nil
        defaultFeedServiceMock = nil

        try super.tearDownWithError()
    }

    // MARK: Tests

    func testInit() {
        XCTAssertEqual(sut.selectedFeed, .best)
        XCTAssertEqual(
            defaultFeedServiceMock.defaultFeedCallCount,
            1
        )
    }
}
