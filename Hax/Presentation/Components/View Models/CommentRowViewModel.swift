//
//  CommentRowViewModel.swift
//  Hax
//
//  Created by Luis Fariña on 20/6/22.
//

import SwiftUI

protocol CommentRowViewModelProtocol {

    // MARK: Types

    typealias OnUserTap = () -> Void
    typealias OnLinkTap = (URL) -> OpenURLAction.Result

    // MARK: Properties

    /// The comment whose information is to be displayed on the row.
    var comment: Comment { get }

    /// The action to be carried out when tapping the user.
    var onUserTap: OnUserTap? { get }

    /// The action to be carried out when tapping a link in the body of the comment.
    var onLinkTap: OnLinkTap? { get }

    /// Whether the author of the comment should be highlighted.
    var shouldHighlightAuthor: Bool { get }
}

struct CommentRowViewModel: CommentRowViewModelProtocol {

    // MARK: Properties

    let comment: Comment
    let onUserTap: OnUserTap?
    let onLinkTap: OnLinkTap?
    let shouldHighlightAuthor: Bool

    // MARK: Initialization

    init(
        comment: Comment,
        item: Item,
        onUserTap: OnUserTap? = nil,
        onLinkTap: OnLinkTap? = nil
    ) {
        self.comment = comment
        self.onUserTap = onUserTap
        self.onLinkTap = onLinkTap
        shouldHighlightAuthor = comment.item.author == item.author
    }
}
