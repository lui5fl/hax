//
//  Feed.swift
//  Hax
//
//  Created by Luis Fariña on 8/5/22.
//

import AppIntents

enum Feed: String, CaseIterable {

    // MARK: Cases

    case top, new, best, ask, show, jobs

    // MARK: Properties

    /// The name of the resource in the API to retrieve the stories from the corresponding list.
    var resource: String {
        let resource: String
        switch self {
        case .top:
            resource = "topstories"
        case .new:
            resource = "newstories"
        case .best:
            resource = "beststories"
        case .ask:
            resource = "askstories"
        case .show:
            resource = "showstories"
        case .jobs:
            resource = "jobstories"
        }

        return resource
    }

    /// The name of the SF Symbol corresponding to the feed.
    var systemImage: String {
        let systemImage: String
        switch self {
        case .top:
            systemImage = "chart.bar"
        case .new:
            systemImage = "clock"
        case .best:
            systemImage = "star"
        case .ask:
            systemImage = "bubble.left.and.bubble.right"
        case .show:
            systemImage = "desktopcomputer"
        case .jobs:
            systemImage = "briefcase"
        }

        return systemImage
    }

    /// The title of the feed.
    var title: String {
        let title: String
        switch self {
        case .top:
            title = String(localized: "Top")
        case .new:
            title = String(localized: "New")
        case .best:
            title = String(localized: "Best")
        case .ask:
            title = String(localized: "Ask")
        case .show:
            title = String(localized: "Show")
        case .jobs:
            title = String(localized: "Jobs")
        }

        return title
    }
}

// MARK: - AppEnum

extension Feed: AppEnum {

    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "Feed"
    }

    static var caseDisplayRepresentations: [Feed: DisplayRepresentation] {
        [
            .top: "Top",
            .new: "New",
            .best: "Best",
            .ask: "Ask",
            .show: "Show",
            .jobs: "Jobs"
        ]
    }
}

// MARK: - Identifiable

extension Feed: Identifiable {

    var id: Self {
        self
    }
}
