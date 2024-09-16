//
//  AppVersionServiceTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 20/12/22.
//

import Testing
@testable import Hax

struct AppVersionServiceTests {

    // MARK: Properties

    private let sut: AppVersionService
    private let bundleMock: BundleMock

    // MARK: Initialization

    init() {
        bundleMock = BundleMock()
        sut = AppVersionService(bundle: bundleMock)
    }

    // MARK: Tests

    @Test func appVersion_givenVersionIsNil() {
        // When
        let appVersion = sut.appVersion()

        // Then
        #expect(appVersion == nil)
        #expect(bundleMock.objectCallCount == 1)
    }

    @Test func appVersion_givenBuildIsNil() {
        // Given
        bundleMock.infoDictionaryStub = [
            "CFBundleShortVersionString": "1.2.3"
        ]

        // When
        let appVersion = sut.appVersion()

        // Then
        #expect(appVersion == nil)
        #expect(bundleMock.objectCallCount == 2)
    }

    @Test func appVersion_givenVersionAndBuildAreNotNil() {
        // Given
        bundleMock.infoDictionaryStub = [
            "CFBundleShortVersionString": "1.2.3",
            "CFBundleVersion": "4"
        ]

        // When
        let appVersion = sut.appVersion()

        // Then
        #expect(appVersion == "1.2.3 (4)")
        #expect(bundleMock.objectCallCount == 2)
    }
}
