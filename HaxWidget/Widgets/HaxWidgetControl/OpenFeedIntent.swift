//
//  OpenFeedIntent.swift
//  HaxWidgetExtension
//
//  Created by Luis Fariña on 22/8/24.
//

import AppIntents

@available(iOS 18.0, *)
struct OpenFeedIntent: ControlConfigurationIntent {

    // MARK: Properties

    static let title: LocalizedStringResource = "Open Feed"
    static let openAppWhenRun = true

    @Parameter(title: "Feed", default: .top)
    var feed: Feed

    // MARK: Methods

    func perform() async throws -> some IntentResult {
        UserDefaults.standard.set(
            "\(Constant.hackerNewsFeedURLString)\(feed.rawValue)",
            forKey: UserDefaults.Key.url
        )

        return .result()
    }
}
