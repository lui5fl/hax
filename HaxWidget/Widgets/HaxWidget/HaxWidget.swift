//
//  HaxWidget.swift
//  HaxWidget
//
//  Created by Luis Fariña on 17/9/23.
//

import SwiftUI
import WidgetKit

struct HaxWidgetEntryView: View {

    // MARK: Properties

    let entry: HaxWidgetProvider.Entry

    // MARK: Body

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 5) {
                Image(systemName: entry.feed.systemImage)
                Text(entry.feed.title)
                    .bold()
            }
            .foregroundStyle(Color(.accent))
            if entry.items.isEmpty {
                Spacer()
                ErrorView("There was an error fetching the items.")
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .center
                    )
                Spacer()
            } else {
                ForEach(
                    Array(entry.items.enumerated()),
                    id: \.element
                ) { index, item in
                    Spacer()
                    Link(destination: URL(string: "hax://item/\(item.id)")!) {
                        HStack {
                            Text(String(index + 1))
                                .foregroundColor(.secondary)
                                .frame(width: 10, alignment: .center)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            Divider()
                            Text(item.title ?? "")
                                .lineSpacing(3)
                        }
                    }
                }
            }
        }
        .containerBackground(for: .widget) {
            // System background color
        }
        .font(.system(size: 15))
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .leading
        )
    }
}

struct HaxWidget: Widget {

    // MARK: Body

    @MainActor
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: String(describing: Self.self),
            intent: SelectFeedIntent.self,
            provider: HaxWidgetProvider()
        ) { entry in
            HaxWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Feed")
        .description("Displays the latest stories from the specified feed.")
    }
}

// MARK: - Previews

#Preview("Small", as: .systemSmall) {
    HaxWidget()
} timeline: {
    HaxWidgetEntry(
        feed: .top,
        items: WidgetFamily.systemSmall.exampleItems
    )
    HaxWidgetEntry(feed: .top, items: [])
}

#Preview("Medium", as: .systemMedium) {
    HaxWidget()
} timeline: {
    HaxWidgetEntry(
        feed: .new,
        items: WidgetFamily.systemMedium.exampleItems
    )
    HaxWidgetEntry(feed: .new, items: [])
}

#Preview("Large", as: .systemLarge) {
    HaxWidget()
} timeline: {
    HaxWidgetEntry(
        feed: .best,
        items: WidgetFamily.systemLarge.exampleItems
    )
    HaxWidgetEntry(feed: .best, items: [])
}
