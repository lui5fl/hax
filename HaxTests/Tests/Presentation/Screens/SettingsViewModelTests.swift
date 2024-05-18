//
//  SettingsViewModelTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 20/12/22.
//

import XCTest
@testable import Hax

@MainActor
final class SettingsViewModelTests: XCTestCase {

    // MARK: Properties

    private var sut: SettingsViewModel!
    private var appVersionServiceMock: AppVersionServiceMock!

    // MARK: Set up and tear down

    override func setUpWithError() throws {
        try super.setUpWithError()

        appVersionServiceMock = AppVersionServiceMock()
        appVersionServiceMock.appVersionStub = "1.2.3 (4)"
        sut = SettingsViewModel(appVersionService: appVersionServiceMock)
    }

    override func tearDownWithError() throws {
        sut = nil

        try super.tearDownWithError()
    }

    // MARK: Tests

    func testInit() {
        XCTAssertEqual(sut.feeds, Feed.allCases)
        XCTAssertEqual(sut.version, "1.2.3 (4)")
        XCTAssertEqual(
            sut.defaultFeed,
            DefaultFeedService().defaultFeed()
        )
        XCTAssertNil(sut.url)
        XCTAssertEqual(appVersionServiceMock.appVersionCallCount, 1)
    }

    func testOnPrivacyPolicyButtonTrigger() {
        // When
        sut.onPrivacyPolicyButtonTrigger()

        // Then
        XCTAssertEqual(
            sut.url?.url.absoluteString,
            "https://luisfl.me/hax/privacy-policy"
        )
    }
}
