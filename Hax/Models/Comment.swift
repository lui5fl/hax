//
//  Comment.swift
//  Hax
//
//  Created by Luis Fariña on 19/5/22.
//

struct Comment: Hashable {

    /// The item corresponding to the comment.
    let item: Item

    /// The depth of the comment in relation to the root item.
    let depth: Int

    /// Whether the comment is collapsed or not in the item view.
    var isCollapsed = false

    /// Whether the comment is hidden or not in the item view.
    var isHidden = false
}

// MARK: - Equatable

extension Comment: Equatable {

    static func == (lhs: Comment, rhs: Comment) -> Bool {
        lhs.id == rhs.id &&
        lhs.depth == rhs.depth &&
        lhs.isCollapsed == rhs.isCollapsed &&
        lhs.isHidden == rhs.isHidden
    }
}

// MARK: - Identifiable

extension Comment: Identifiable {

    var id: Int {
        item.id
    }
}

// MARK: - Example data

extension Comment {

    static func example(
        id: Int = 0,
        depth: Int,
        isCollapsed: Bool = false
    ) -> Self {
        Comment(
            item: .example(id: id),
            depth: depth,
            isCollapsed: isCollapsed
        )
    }
}
