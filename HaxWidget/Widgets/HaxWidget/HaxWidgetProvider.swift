//
//  HaxWidgetProvider.swift
//  HaxWidgetExtension
//
//  Created by Luis Fariña on 17/9/23.
//

import SwiftData
import WidgetKit

struct HaxWidgetProvider: AppIntentTimelineProvider {

    // MARK: Initialization

    @MainActor
    init() {
        let modelConfiguration = ModelConfiguration()
        let modelContainer = try? ModelContainer(
            for: KeywordFilter.self,
            UserFilter.self,
            configurations: modelConfiguration
        )
        HackerNewsService.shared.filterService = modelContainer.map {
            FilterService(modelContext: $0.mainContext)
        }
    }

    // MARK: Methods

    func placeholder(in context: Context) -> HaxWidgetEntry {
        HaxWidgetEntry(
            feed: .top,
            items: context.family.exampleItems
        )
    }

    func snapshot(
        for configuration: SelectFeedIntent,
        in context: Context
    ) async -> HaxWidgetEntry {
        await entry(for: configuration, in: context)
    }

    func timeline(
        for configuration: SelectFeedIntent,
        in context: Context
    ) async -> Timeline<HaxWidgetEntry> {
        Timeline(
            entries: [await entry(for: configuration, in: context)],
            policy: .after(
                Calendar.current.date(
                    byAdding: .hour,
                    value: configuration.feed.numberOfHoursUntilNewTimeline,
                    to: .now
                )!
            )
        )
    }
}

// MARK: - Private extension

private extension HaxWidgetProvider {

    // MARK: Methods

    func entry(
        for configuration: SelectFeedIntent,
        in context: Context
    ) async -> HaxWidgetEntry {
        HaxWidgetEntry(
            feed: configuration.feed,
            items: (
                try? await HackerNewsService.shared.items(
                    in: configuration.feed,
                    page: 1,
                    pageSize: context.family.numberOfItems,
                    resetCache: true
                )
            ) ?? []
        )
    }
}
