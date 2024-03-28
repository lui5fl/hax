//
//  ItemRowViewModel.swift
//  Hax
//
//  Created by Luis Fariña on 27/5/22.
//

import SwiftUI

enum ItemRowViewModelView: CaseIterable {

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

protocol ItemRowViewModelProtocol {

    // MARK: Properties

    /// The type of view the row is being displayed on.
    var view: ItemRowViewModelView { get }

    /// The index of the item in the feed.
    var index: Int { get }

    /// The item whose information is to be displayed on the row.
    var item: Item { get }

    /// The action to be carried out when tapping the number of comments.
    var onNumberOfCommentsTap: (() -> Void)? { get }

    /// The action to be carried out when tapping a link in the body of the item.
    var onLinkTap: ((URL) -> OpenURLAction.Result)? { get }

    /// Whether the index of the item should be displayed.
    var shouldDisplayIndex: Bool { get }

    /// Whether the body of the item should be displayed.
    var shouldDisplayBody: Bool { get }

    /// Whether the author of the item should be displayed.
    var shouldDisplayAuthor: Bool { get }

    /// Whether the score of the item should be displayed.
    var shouldDisplayScore: Bool { get }

    /// Whether the number of comments should be displayed.
    var shouldDisplayNumberOfComments: Bool { get }
}

struct ItemRowViewModel: ItemRowViewModelProtocol {

    // MARK: Properties

    let view: ItemRowViewModelView
    let index: Int
    let item: Item
    let onNumberOfCommentsTap: (() -> Void)?
    let onLinkTap: ((URL) -> OpenURLAction.Result)?

    var shouldDisplayIndex: Bool {
        view == .feed
    }

    var shouldDisplayBody: Bool {
        view == .item
    }

    var shouldDisplayAuthor: Bool {
        view == .item
    }

    var shouldDisplayScore: Bool {
        item.kind != .job
    }

    var shouldDisplayNumberOfComments: Bool {
        view == .feed && item.kind != .job
    }

    // MARK: Initialization

    init(
        in view: ItemRowViewModelView,
        index: Int = 1,
        item: Item,
        onNumberOfCommentsTap: (() -> Void)? = nil,
        onLinkTap: ((URL) -> OpenURLAction.Result)? = nil
    ) {
        self.view = view
        self.index = index
        self.item = item
        self.onNumberOfCommentsTap = onNumberOfCommentsTap
        self.onLinkTap = onLinkTap
    }
}
