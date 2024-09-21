//
//  HaxWidgetControl.swift
//  HaxWidgetExtension
//
//  Created by Luis Fariña on 21/8/24.
//

import SwiftUI
import WidgetKit

@available(iOSApplicationExtension 18.0, *)
struct HaxWidgetControl: ControlWidget {

    // MARK: Body

    var body: some ControlWidgetConfiguration {
        AppIntentControlConfiguration(
            kind: String(describing: Self.self),
            intent: OpenFeedIntent.self
        ) { openFeedIntent in
            ControlWidgetButton(action: openFeedIntent) {
                Label(
                    openFeedIntent.feed.title,
                    systemImage: openFeedIntent.feed.systemImage
                )
            }
        }
        .description("Opens the specified feed.")
        .displayName("Open Feed")
    }
}
