//
//  SelectFeedIntent.swift
//  HaxWidgetExtension
//
//  Created by Luis Fariña on 10/10/23.
//

import AppIntents

struct SelectFeedIntent: WidgetConfigurationIntent {

    // MARK: Properties

    static let title: LocalizedStringResource = "Select Feed"
    static let description = IntentDescription("Selects the feed whose items are to be fetched.")

    @Parameter(title: "Feed", default: .top)
    var feed: Feed
}
