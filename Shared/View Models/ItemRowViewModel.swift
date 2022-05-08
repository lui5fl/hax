//
//  ItemRowViewModel.swift
//  Hax
//
//  Created by Luis Fariña on 27/5/22.
//

import Foundation

struct ItemRowViewModel {

    // MARK: Types

    enum View: CaseIterable {

        // MARK: Cases

        case feed, item

        // MARK: Properties

        /// The name for the SwiftUI preview.
        var previewDisplayName: String {
            let previewDisplayName: String
            switch self {
            case .feed:
                previewDisplayName = "Feed"
            case .item:
                previewDisplayName = "Item"
            }

            return previewDisplayName
        }
    }

    // MARK: Properties

    /// The type of view the row is being displayed on.
    let view: View

    /// The index of the item in the feed.
    let index: Int

    /// The item whose information is to be displayed on the row.
    let item: Item

    /// The action to be carried out when tapping the number of comments.
    let onNumberOfCommentsTap: (() -> Void)?

    /// The action to be carried out when tapping a link in the body of the item.
    let onLinkTap: ((URL) -> Void)?

    /// Whether the index of the item should be displayed or not.
    var shouldDisplayIndex: Bool {
        view == .feed
    }

    /// Whether the body of the item should be displayed or not.
    var shouldDisplayBody: Bool {
        view == .item
    }

    /// Whether the author of the item should be displayed or not.
    var shouldDisplayAuthor: Bool {
        view == .item
    }

    /// Whether the score of the item should be displayed or not.
    var shouldDisplayScore: Bool {
        item.kind != .job
    }

    /// Whether the number of comments should be displayed or not.
    var shouldDisplayNumberOfComments: Bool {
        view == .feed && item.kind != .job
    }

    // MARK: Initialization

    init(
        in view: View,
        index: Int = 1,
        item: Item,
        onNumberOfCommentsTap: (() -> Void)? = nil,
        onLinkTap: ((URL) -> Void)? = nil
    ) {
        self.view = view
        self.index = index
        self.item = item
        self.onNumberOfCommentsTap = onNumberOfCommentsTap
        self.onLinkTap = onLinkTap
    }
}
