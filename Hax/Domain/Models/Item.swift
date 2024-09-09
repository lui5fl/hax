//
//  Item.swift
//  Hax
//
//  Created by Luis Fariña on 8/5/22.
//

import Foundation

struct Item: Hashable, Identifiable, Sendable {

    // MARK: Types

    enum Kind: String, CaseIterable {

        // MARK: Cases

        case comment, job, story
    }

    // MARK: Properties

    /// The identifier of the item.
    let id: Int

    /// Whether the item has been deleted.
    let deleted: Bool

    /// The kind of the item.
    let kind: Kind?

    /// The author of the item.
    let author: String?

    /// The body of the item.
    let body: String?

    /// Whether the item has been "killed" by software / user flags / moderators.
    let dead: Bool

    /// The children of the item.
    let children: [Self]

    /// The URL of the item.
    let url: URL?

    /// The score of the item.
    let score: Int?

    /// The title of the item.
    let title: String?

    /// The number of descendants of the item.
    let descendants: Int?

    /// The comments of the item.
    let comments: [Comment]

    /// The identifier of the story that the comment is associated to.
    let storyId: Int?

    /// The body of the item in Markdown.
    let markdownBody: String?

    /// The URL in a simplified form as a string.
    let urlSimpleString: String?

    /// The elapsed time between the date of the item and the current date, as a string.
    let elapsedTimeString: String?

    /// The URL for the item's discussion on Hacker News.
    let hackerNewsURL: URL?

    // MARK: Initialization

    init(
        id: Int = .zero,
        deleted: Bool = false,
        kind: Kind? = nil,
        author: String? = nil,
        date: Date? = nil,
        body: String? = nil,
        dead: Bool = false,
        children: [Self] = [],
        url: URL? = nil,
        score: Int? = nil,
        title: String? = nil,
        descendants: Int? = nil,
        comments: [Comment] = [],
        storyId: Int? = nil
    ) {
        self.id = id
        self.deleted = deleted
        self.kind = kind
        self.author = author
        self.body = body
        self.dead = dead
        self.children = children
        self.url = url
        self.score = score
        self.title = title
        self.descendants = descendants
        self.comments = comments
        self.storyId = storyId

        markdownBody = body?.htmlToMarkdown()
        urlSimpleString = url?.simpleString()
        elapsedTimeString = date?.elapsedTimeString()
        hackerNewsURL = URL(
            string: "https://\(Constant.hackerNewsItemURLString)\(id)"
        )
    }

    init(algoliaItemDTO: AlgoliaItemDTO) {
        self.init(
            id: algoliaItemDTO.id,
            deleted: algoliaItemDTO.author == nil,
            kind: Kind(rawValue: algoliaItemDTO.type),
            author: algoliaItemDTO.author,
            date: Date(
                timeIntervalSince1970: TimeInterval(
                    algoliaItemDTO.createdAtI
                )
            ),
            body: algoliaItemDTO.text,
            children: algoliaItemDTO.children.map(
                Self.init(algoliaItemDTO:)
            ),
            url: algoliaItemDTO.url.flatMap(URL.init),
            score: algoliaItemDTO.points,
            title: algoliaItemDTO.title,
            storyId: algoliaItemDTO.storyId
        )
    }

    init(algoliaSearchResultDTO: AlgoliaSearchResultDTO) {
        self.init(
            id: Int(algoliaSearchResultDTO.objectID)!,
            deleted: algoliaSearchResultDTO.author == nil,
            author: algoliaSearchResultDTO.author,
            date: Date(
                timeIntervalSince1970: TimeInterval(
                    algoliaSearchResultDTO.createdAtI
                )
            ),
            url: algoliaSearchResultDTO.url.flatMap(URL.init),
            score: algoliaSearchResultDTO.points,
            title: algoliaSearchResultDTO.title,
            descendants: algoliaSearchResultDTO.numComments,
            storyId: algoliaSearchResultDTO.storyId
        )
    }

    init(firebaseItemDTO: FirebaseItemDTO) {
        self.init(
            id: firebaseItemDTO.id,
            deleted: firebaseItemDTO.deleted ?? false,
            kind: firebaseItemDTO.type.flatMap(Kind.init),
            author: firebaseItemDTO.by,
            date: firebaseItemDTO.time.map {
                Date(timeIntervalSince1970: TimeInterval($0))
            },
            body: firebaseItemDTO.text,
            dead: firebaseItemDTO.dead ?? false,
            url: firebaseItemDTO.url.flatMap(URL.init),
            score: firebaseItemDTO.score,
            title: firebaseItemDTO.title,
            descendants: firebaseItemDTO.descendants
        )
    }

    init(
        algoliaItemDTO: AlgoliaItemDTO,
        firebaseItemDTO: FirebaseItemDTO,
        filterService: FilterServiceProtocol? = nil
    ) {
        self.init(
            id: firebaseItemDTO.id,
            deleted: firebaseItemDTO.deleted ?? false,
            kind: firebaseItemDTO.type.flatMap(Kind.init),
            author: firebaseItemDTO.by,
            date: firebaseItemDTO.time.map {
                Date(timeIntervalSince1970: TimeInterval($0))
            },
            body: firebaseItemDTO.text,
            dead: firebaseItemDTO.dead ?? false,
            url: firebaseItemDTO.url.flatMap(URL.init),
            score: firebaseItemDTO.score,
            title: firebaseItemDTO.title,
            descendants: firebaseItemDTO.descendants,
            comments: Self.comments(
                item: Item(algoliaItemDTO: algoliaItemDTO),
                childIdentifiers: firebaseItemDTO.kids,
                filterService: filterService
            ),
            storyId: algoliaItemDTO.storyId
        )
    }
}

// MARK: - Example data

extension Item {

    // MARK: Properties

    static let example = example(id: .zero)

    // MARK: Methods

    static func example(id: Int) -> Self {
        Item(
            id: id,
            kind: .story,
            author: "luisfl",
            date: .now,
            body: "This is the body",
            url: URL(string: "https://luisfl.me"),
            score: 42,
            title: "This is the title",
            descendants: 98
        )
    }
}

// MARK: - Private extension

private extension Item {

    // MARK: Methods

    static func comments(
        item: Self,
        depth: Int = .zero,
        childIdentifiers: [Int]? = nil,
        filterService: FilterServiceProtocol? = nil
    ) -> [Comment] {
        var comments: [Comment] = []
        var items: [Self] = []

        if let childIdentifiers {
            var dictionary: [Int: Self] = [:]

            for child in item.children {
                dictionary[child.id] = child
            }

            for id in childIdentifiers {
                if let child = dictionary[id] {
                    items.append(child)
                }
            }
        } else {
            items = item.children
        }

        items = filterService?.filtered(items: items) ?? items

        for child in items {
            comments.append(Comment(item: child, depth: depth))
            comments.append(
                contentsOf: Self.comments(
                    item: child,
                    depth: depth + 1,
                    filterService: filterService
                )
            )
        }

        return comments
    }
}
