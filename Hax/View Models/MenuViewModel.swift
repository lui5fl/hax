//
//  MenuViewModel.swift
//  Hax
//
//  Created by Luis Fariña on 26/5/22.
//

import Foundation

@MainActor final class MenuViewModel: ObservableObject {

    // MARK: Properties

    /// The selected feed.
    @Published var feed: Feed?

    /// The array of feeds to display in the list.
    let feeds = Feed.allCases

    // MARK: Initialization

    init() {
        let defaultFeedRawValue = UserDefaults.standard.string(
            forKey: UserDefaults.Key.defaultFeed
        ) ?? ""

        feed = Feed(rawValue: defaultFeedRawValue)
    }
}
