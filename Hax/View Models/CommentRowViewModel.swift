//
//  CommentRowViewModel.swift
//  Hax
//
//  Created by Luis Fariña on 20/6/22.
//

import Foundation

protocol CommentRowViewModelProtocol {

    // MARK: Properties

    /// The comment whose information is to be displayed on the row.
    var comment: Comment { get }

    /// The action to be carried out when tapping a link in the body of the comment.
    var onLinkTap: ((URL) -> Void)? { get }

    /// Whether the author of the comment should be highlighted.
    var shouldHighlightAuthor: Bool { get }
}

struct CommentRowViewModel: CommentRowViewModelProtocol {

    // MARK: Properties

    let comment: Comment
    let onLinkTap: ((URL) -> Void)?
    let shouldHighlightAuthor: Bool

    // MARK: Initialization

    init(
        comment: Comment,
        item: Item,
        onLinkTap: ((URL) -> Void)? = nil
    ) {
        self.comment = comment
        self.onLinkTap = onLinkTap
        shouldHighlightAuthor = comment.item.author == item.author
    }
}
