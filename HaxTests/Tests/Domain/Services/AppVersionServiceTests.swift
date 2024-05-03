//
//  AppVersionServiceTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 20/12/22.
//

import XCTest
@testable import Hax

final class AppVersionServiceTests: XCTestCase {

    // MARK: Properties

    private var sut: AppVersionService!
    private var bundleMock: BundleMock!

    // MARK: Set up and tear down

    override func setUpWithError() throws {
        try super.setUpWithError()

        bundleMock = BundleMock()
        sut = AppVersionService(bundle: bundleMock)
    }

    override func tearDownWithError() throws {
        sut = nil
        bundleMock = nil

        try super.tearDownWithError()
    }

    // MARK: Methods

    func testAppVersion_givenVersionIsNil() {
        // When
        let appVersion = sut.appVersion()

        // Then
        XCTAssertNil(appVersion)
        XCTAssertEqual(bundleMock.objectCallCount, 1)
    }

    func testAppVersion_givenBuildIsNil() {
        // Given
        bundleMock.infoDictionaryStub = [
            "CFBundleShortVersionString": "1.2.3"
        ]

        // When
        let appVersion = sut.appVersion()

        // Then
        XCTAssertNil(appVersion)
        XCTAssertEqual(bundleMock.objectCallCount, 2)
    }

    func testAppVersion_givenVersionAndBuildAreNotNil() {
        // Given
        bundleMock.infoDictionaryStub = [
            "CFBundleShortVersionString": "1.2.3",
            "CFBundleVersion": "4"
        ]

        // When
        let appVersion = sut.appVersion()

        // Then
        XCTAssertEqual(appVersion, "1.2.3 (4)")
        XCTAssertEqual(bundleMock.objectCallCount, 2)
    }
}
