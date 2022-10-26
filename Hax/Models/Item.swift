//
//  Item.swift
//  Hax
//
//  Created by Luis Fariña on 8/5/22.
//

import Foundation

struct Item: Hashable {

    // MARK: Types

    enum Kind: String, Decodable {
        case comment, job, story
    }

    // MARK: Properties

    /// The identifier of the item.
    let id: Int

    /// Whether the item has been deleted or not.
    let deleted: Bool

    /// The kind of the item.
    let kind: Kind?

    /// The author of the item.
    let author: String?

    /// The date that the item has been submitted on.
    let date: Date?

    /// The body of the item.
    let body: String?

    /// Whether the item has been "killed" by software / user flags / moderators or not.
    let dead: Bool

    /// The identifiers of the children of the item.
    let children: [Int]

    /// The URL of the item.
    let url: URL?

    /// The score of the item.
    let score: Int?

    /// The title of the item.
    let title: String?

    /// The number of descendants of the item.
    let descendants: Int?

    /// The body of the item in Markdown.
    let markdownBody: String?

    /// The URL in a simplified form as a string.
    let urlSimpleString: String?

    /// The elapsed time between the date of the item and the current date, as a string.
    let elapsedTimeString: String?

    // MARK: Initialization

    init(
        id: Int,
        deleted: Bool,
        kind: Kind?,
        author: String?,
        date: Date?,
        body: String?,
        dead: Bool,
        children: [Int],
        url: URL?,
        score: Int?,
        title: String?,
        descendants: Int?
    ) {
        self.id = id
        self.deleted = deleted
        self.kind = kind
        self.author = author
        self.date = date
        self.body = body
        self.dead = dead
        self.children = children
        self.url = url
        self.score = score
        self.title = title
        self.descendants = descendants

        markdownBody = body?.htmlToMarkdown()
        urlSimpleString = url?.simpleString()
        elapsedTimeString = date?.elapsedTimeString()
    }
}

// MARK: - Decodable

extension Item: Decodable {

    // swiftlint:disable function_body_length
    init(from decoder: Decoder) throws {
        let container = try decoder.container(
            keyedBy: CodingKeys.self
        )

        let id = try container.decode(Int.self, forKey: .id)

        let deleted = try container.decodeIfPresent(
            Bool.self,
            forKey: .deleted
        ) ?? false

        let kind = try? container.decodeIfPresent(
            Kind.self,
            forKey: .kind
        )

        let author = try container.decodeIfPresent(
            String.self,
            forKey: .author
        )

        let date = try container.decodeIfPresent(
            Date.self,
            forKey: .date
        )

        let body = try container.decodeIfPresent(
            String.self,
            forKey: .body
        )

        let dead = try container.decodeIfPresent(
            Bool.self,
            forKey: .dead
        ) ?? false

        let children = try container.decodeIfPresent(
            [Int].self,
            forKey: .children
        ) ?? []

        let url = try container.decodeIfPresent(
            URL.self,
            forKey: .url
        )

        let score = try container.decodeIfPresent(
            Int.self,
            forKey: .score
        )

        let title = try container.decodeIfPresent(
            String.self,
            forKey: .title
        )

        let descendants = try container.decodeIfPresent(
            Int.self,
            forKey: .descendants
        )

        self.init(
            id: id,
            deleted: deleted,
            kind: kind,
            author: author,
            date: date,
            body: body,
            dead: dead,
            children: children,
            url: url,
            score: score,
            title: title,
            descendants: descendants
        )
    }
    // swiftlint:enable function_body_length
}

// MARK: - Example data

extension Item {

    static let example = example(id: 0)

    static func example(id: Int) -> Self {
        Item(
            id: id,
            deleted: false,
            kind: .story,
            author: "luisfl",
            date: .now,
            body: "This is the body",
            dead: false,
            children: [],
            url: URL(string: "https://luisfl.me"),
            score: 42,
            title: "This is the title",
            descendants: 98
        )
    }
}

// MARK: - Private extension

private extension Item {

    enum CodingKeys: String, CodingKey {
        case id
        case deleted
        case kind = "type"
        case author = "by"
        case date = "time"
        case body = "text"
        case dead
        case children = "kids"
        case url
        case score
        case title
        case descendants
    }
}
