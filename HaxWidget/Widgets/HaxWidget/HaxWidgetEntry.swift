//
//  HaxWidgetEntry.swift
//  HaxWidgetExtension
//
//  Created by Luis Fariña on 17/9/23.
//

import WidgetKit

struct HaxWidgetEntry: TimelineEntry {

    // MARK: Properties

    let date: Date
    let feed: Feed
    let items: [Item]

    // MARK: Initialization

    init(
        date: Date = .now,
        feed: Feed,
        items: [Item]
    ) {
        self.date = date
        self.feed = feed
        self.items = items
    }
}
