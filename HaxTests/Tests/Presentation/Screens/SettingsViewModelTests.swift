//
//  SettingsViewModelTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 20/12/22.
//

import Testing
@testable import Hax

@MainActor
struct SettingsViewModelTests {

    // MARK: Properties

    private let sut: SettingsViewModel
    private let appVersionServiceMock: AppVersionServiceMock

    // MARK: Initialization

    init() {
        appVersionServiceMock = AppVersionServiceMock()
        appVersionServiceMock.appVersionStub = "1.2.3 (4)"
        sut = SettingsViewModel(appVersionService: appVersionServiceMock)
    }

    // MARK: Tests

    @Test func initialize() {
        #expect(sut.feeds == Feed.allCases)
        #expect(sut.version == "1.2.3 (4)")
        #expect(
            sut.defaultFeed ==
            DefaultFeedService().defaultFeed()
        )
        #expect(sut.url == nil)
        #expect(appVersionServiceMock.appVersionCallCount == 1)
    }

    @Test func onSafariExtensionButtonTrigger() {
        // When
        sut.onSafariExtensionButtonTrigger()

        // Then
        #expect(
            sut.url?.url.absoluteString ==
            "https://luisfl.me/hax/help/safari-extension"
        )
    }

    @Test func onPrivacyPolicyButtonTrigger() {
        // When
        sut.onPrivacyPolicyButtonTrigger()

        // Then
        #expect(
            sut.url?.url.absoluteString ==
            "https://luisfl.me/hax/privacy-policy"
        )
    }
}
