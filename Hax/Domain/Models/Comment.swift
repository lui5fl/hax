//
//  Comment.swift
//  Hax
//
//  Created by Luis Fariña on 19/5/22.
//

struct Comment: Hashable {

    // MARK: Properties

    /// The item corresponding to the comment.
    let item: Item

    /// The depth of the comment in relation to the root item.
    let depth: Int

    /// Whether the comment is collapsed in the item view.
    var isCollapsed: Bool

    /// Whether the comment is hidden in the item view.
    var isHidden: Bool

    // MARK: Initialization

    init(
        item: Item,
        depth: Int = .zero,
        isCollapsed: Bool = false,
        isHidden: Bool = false
    ) {
        self.item = item
        self.depth = depth
        self.isCollapsed = isCollapsed
        self.isHidden = isHidden
    }
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

    // MARK: Properties

    static let example = example()

    // MARK: Methods

    static func example(
        id: Int = .zero,
        depth: Int = .zero,
        isCollapsed: Bool = false
    ) -> Self {
        Comment(
            item: .example(id: id),
            depth: depth,
            isCollapsed: isCollapsed
        )
    }
}
