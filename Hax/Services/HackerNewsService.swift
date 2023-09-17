//
//  HackerNewsService.swift
//  Hax
//
//  Created by Luis Fariña on 8/5/22.
//

import Combine
import Foundation

enum HackerNewsServiceError: LocalizedError {

    // MARK: Cases

    case network, unknown

    // MARK: Properties

    var errorDescription: String? {
        let errorDescription: String
        switch self {
        case .network:
            errorDescription = "Network Error"
        case .unknown:
            errorDescription = "Unknown Error"
        }

        return errorDescription
    }

    var recoverySuggestion: String? {
        "Try again later."
    }
}

protocol HackerNewsServiceProtocol {

    /// Returns a publisher that resolves to a specific page of comments in an item.
    ///
    /// - Parameters:
    ///   - item: The item to be fetched
    ///   - page: The page of comments to fetch
    ///   - pageSize: The size of each page
    func comments(
        in item: Item,
        page: Int,
        pageSize: Int
    ) -> AnyPublisher<[Comment], Error>

    /// Returns a publisher that resolves to the item with the specified identifier and its
    /// corresponding information.
    ///
    /// - Parameters:
    ///   - id: The identifier of the item to be fetched
    func item(
        id: Int
    ) -> AnyPublisher<Item, Error>

    /// Returns a publisher that resolves to a specific page of items in a feed.
    ///
    /// - Parameters:
    ///   - feed: The feed whose items are to be fetched
    ///   - page: The page of items to fetch
    ///   - pageSize: The size of each page
    ///   - resetCache: Whether to reset the array of cached item identifiers
    func items(
        in feed: Feed,
        page: Int,
        pageSize: Int,
        resetCache: Bool
    ) -> AnyPublisher<[Item], Error>

    /// Fetches a specific page of comments in an item.
    ///
    /// - Parameters:
    ///   - item: The item to be fetched
    ///   - page: The page of comments to fetch
    ///   - pageSize: The size of each page
    func comments(
        in item: Item,
        page: Int,
        pageSize: Int
    ) async throws -> [Comment]

    /// Fetches the item with the specified identifier and its corresponding information.
    ///
    /// - Parameters:
    ///   - id: The identifier of the item to be fetched
    func item(
        id: Int
    ) async throws -> Item

    /// Fetches a specific page of items in a feed.
    ///
    /// - Parameters:
    ///   - feed: The feed whose items are to be fetched
    ///   - page: The page of items to fetch
    ///   - pageSize: The size of each page
    ///   - resetCache: Whether to reset the array of cached item identifiers
    func items(
        in feed: Feed,
        page: Int,
        pageSize: Int,
        resetCache: Bool
    ) async throws -> [Item]
}

final class HackerNewsService: HackerNewsServiceProtocol {

    // MARK: Properties

    /// The instance to be shared across the application.
    static let shared = HackerNewsService()

    /// The array of cached item identifiers from the last visited feed.
    private var cachedIdentifiers: [Int] = []

    /// The decoder to use for every request so that any date is decoded properly.
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970

        return decoder
    }()

    // MARK: HackerNewsServiceProtocol

    func comments(
        in item: Item,
        page: Int,
        pageSize: Int = Constant.itemPageSize
    ) -> AnyPublisher<[Comment], Error> {
        let identifiersForPage = item.children
            .dropFirst(pageSize * (page - 1))
            .prefix(pageSize)

        return comments(for: Array(identifiersForPage))
    }

    func item(
        id: Int
    ) -> AnyPublisher<Item, Error> {
        guard let url = Endpoint.item(id).url else {
            return Fail(error: HackerNewsServiceError.unknown)
                .eraseToAnyPublisher()
        }

        return request(url: url)
    }

    func items(
        in feed: Feed,
        page: Int,
        pageSize: Int = Constant.feedPageSize,
        resetCache: Bool = false
    ) -> AnyPublisher<[Item], Error> {
        identifiers(for: feed, resetCache: resetCache)
            .flatMap { [weak self] identifiers -> AnyPublisher<[Item], Error> in
                guard let self = self else {
                    return Fail(error: HackerNewsServiceError.unknown)
                        .eraseToAnyPublisher()
                }

                let identifiersForPage = identifiers
                    .dropFirst(pageSize * (page - 1))
                    .prefix(pageSize)

                return self.items(for: Array(identifiersForPage))
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    func comments(
        in item: Item,
        page: Int,
        pageSize: Int
    ) async throws -> [Comment] {
        try await comments(
            in: item,
            page: page,
            pageSize: pageSize
        ).async()
    }

    func item(
        id: Int
    ) async throws -> Item {
        try await item(id: id).async()
    }

    func items(
        in feed: Feed,
        page: Int,
        pageSize: Int,
        resetCache: Bool
    ) async throws -> [Item] {
        try await items(
            in: feed,
            page: page,
            pageSize: pageSize,
            resetCache: resetCache
        ).async()
    }
}

// MARK: - Private extension

private extension HackerNewsService {

    // MARK: Types

    enum Constant {
        static let feedPageSize = 10
        static let itemPageSize = 5
    }

    enum Endpoint {

        // MARK: Cases

        case feed(Feed)
        case item(Int)

        // MARK: Properties

        var url: URL? {
            var url = URL(string: "https://hacker-news.firebaseio.com/v0")
            switch self {
            case .feed(let feed):
                url?.appendPathComponent("\(feed.resource).json")
            case .item(let id):
                url?.appendPathComponent("item")
                url?.appendPathComponent("\(id).json")
            }

            return url
        }
    }

    // MARK: Methods

    func comments(
        for identifiers: [Int],
        depth: Int = 0
    ) -> AnyPublisher<[Comment], Error> {
        // Fetch the items for the specified identifiers
        items(for: identifiers)
            .map { items in
                // Transform each item into a comment
                items.map {
                    Comment(item: $0, depth: depth)
                }
            }
            .flatMap { [weak self] comments -> AnyPublisher<[Comment], Error> in
                guard let self = self else {
                    return Fail(error: HackerNewsServiceError.unknown)
                        .eraseToAnyPublisher()
                }

                // For each comment publish both itself and its descendants,
                // once the latter are fetched
                var publishers: [AnyPublisher<(Comment, [Comment]), Error>] = []
                for comment in comments {
                    publishers.append(
                        Publishers.Zip(
                            Just(comment).setFailureType(to: Error.self),
                            self.comments(
                                for: comment.item.children,
                                depth: depth + 1
                            )
                        )
                            .eraseToAnyPublisher()
                    )
                }

                return Publishers.MergeMany(publishers)
                    .collect()
                    .map { tuples in
                        // Sort the comments following the order
                        // established by the server
                        var dictionary: [Int: (Comment, [Comment])] = [:]
                        tuples.forEach { tuple in
                            dictionary[tuple.0.id] = tuple
                        }
                        let sortedTuples = comments.compactMap { comment in
                            dictionary[comment.id]
                        }

                        return sortedTuples
                            .flatMap { tuple in
                                [tuple.0] + tuple.1
                            }
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    func items(for identifiers: [Int]) -> AnyPublisher<[Item], Never> {
        // Get the items for the specified identifiers
        Publishers.MergeMany(identifiers.map {
            item(id: $0)
                .map(Optional.some)
                .replaceError(with: nil)
        })
            .collect()
            .map { items in
                let items = items.compactMap { $0 }

                // Sort the items following the order established
                // by the server
                var dictionary: [Int: Item] = [:]
                items.forEach { item in
                    dictionary[item.id] = item
                }
                let sortedItems = identifiers.compactMap { identifier in
                    dictionary[identifier]
                }

                return sortedItems.filter { !$0.deleted && !$0.dead }
            }
            .eraseToAnyPublisher()
    }

    func identifiers(
        for feed: Feed,
        resetCache: Bool
    ) -> AnyPublisher<[Int], Error> {
        guard let url = Endpoint.feed(feed).url else {
            return Fail(error: HackerNewsServiceError.unknown)
                .eraseToAnyPublisher()
        }

        let identifiers: AnyPublisher<[Int], Error>
        if resetCache {
            cachedIdentifiers = []
        }
        if !cachedIdentifiers.isEmpty {
            identifiers = Just(cachedIdentifiers)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            identifiers = request(url: url)
                .map { [weak self] (ids: [Int]) -> [Int] in
                    guard let self = self else {
                        return []
                    }

                    self.cachedIdentifiers = ids

                    return ids
                }
                .eraseToAnyPublisher()
        }

        return identifiers
    }

    func request<T: Decodable>(url: URL) -> AnyPublisher<T, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: T.self, decoder: decoder)
            .mapError { _ in
                HackerNewsServiceError.network
            }
            .eraseToAnyPublisher()
    }
}
