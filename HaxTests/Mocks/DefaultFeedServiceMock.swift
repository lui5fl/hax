//
//  DefaultFeedServiceMock.swift
//  HaxTests
//
//  Created by Luis Fariña on 20/12/22.
//

@testable import Hax

final class DefaultFeedServiceMock: DefaultFeedServiceProtocol {

    // MARK: Properties

    var defaultFeedStub: Feed?
    private(set) var defaultFeedCallCount = 0

    // MARK: Methods

    func defaultFeed() -> Feed? {
        defaultFeedCallCount += 1

        return defaultFeedStub
    }
}
