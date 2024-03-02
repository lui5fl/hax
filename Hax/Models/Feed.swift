//
//  Feed.swift
//  Hax
//
//  Created by Luis Fariña on 8/5/22.
//

import Foundation

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
            title = "Top"
        case .new:
            title = "New"
        case .best:
            title = "Best"
        case .ask:
            title = "Ask"
        case .show:
            title = "Show"
        case .jobs:
            title = "Jobs"
        }

        return title
    }
}

// MARK: - Identifiable

extension Feed: Identifiable {

    var id: Self {
        self
    }
}
