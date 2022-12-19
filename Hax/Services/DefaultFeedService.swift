//
//  DefaultFeedService.swift
//  Hax
//
//  Created by Luis Fariña on 20/12/22.
//

import Foundation

protocol DefaultFeedServiceProtocol {

    // MARK: Methods

    /// Returns the default feed.
    func defaultFeed() -> Feed?
}

struct DefaultFeedService: DefaultFeedServiceProtocol {

    // MARK: Properties

    private let userDefaults: UserDefaults
    private let userDefaultsKey: String

    // MARK: Initialization

    init(
        userDefaults: UserDefaults = .standard,
        userDefaultsKey: String = UserDefaults.Key.defaultFeed
    ) {
        self.userDefaults = userDefaults
        self.userDefaultsKey = userDefaultsKey
    }

    // MARK: Methods

    func defaultFeed() -> Feed? {
        userDefaults
            .string(forKey: userDefaultsKey)
            .flatMap(Feed.init)
    }
}
