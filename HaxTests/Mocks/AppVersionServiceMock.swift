//
//  AppVersionServiceMock.swift
//  HaxTests
//
//  Created by Luis Fariña on 20/12/22.
//

@testable import Hax

final class AppVersionServiceMock: AppVersionServiceProtocol {

    // MARK: Properties

    var appVersionStub: String?
    private(set) var appVersionCallCount = 0

    // MARK: Methods

    func appVersion() -> String? {
        appVersionCallCount += 1

        return appVersionStub
    }
}
