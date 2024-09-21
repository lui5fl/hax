//
//  HackerNewsService.swift
//  Hax
//
//  Created by Luis Fariña on 8/5/22.
//

import Foundation
import Networking

enum HackerNewsServiceError: LocalizedError {

    // MARK: Cases

    case network

    // MARK: Properties

    var errorDescription: String? {
        let errorDescription: String

        switch self {
        case .network:
            errorDescription = String(localized: "Network Error")
        }

        return errorDescription
    }

    var recoverySuggestion: String? {
        let recoverySuggestion: String?

        switch self {
        case .network:
            recoverySuggestion = String(localized: "Try again later.")
        }

        return recoverySuggestion
    }
}

protocol HackerNewsServiceProtocol {

    // MARK: Methods

    /// Fetches the item with the specified identifier and its corresponding information.
    ///
    /// - Parameters:
    ///   - id: The identifier of the item to be fetched
    ///   - shouldFetchComments: Whether the comments of the item should be fetched
    func item(
        id: Int,
        shouldFetchComments: Bool
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

    /// Searches for stories matching the specified query and returns the most relevant
    /// results.
    ///
    /// - Parameters:
    ///   - query: The text to be matched
    func search(query: String) async throws -> [Item]

    /// Fetches the user with the specified identifier and its corresponding information.
    ///
    /// - Parameters:
    ///   - id: The identifier of the user to be fetched
    func user(id: String) async throws -> User
}

final class HackerNewsService: HackerNewsServiceProtocol {

    // MARK: Properties

    /// The instance to be shared across the application.
    static let shared = HackerNewsService()

    /// The network client to use for interacting with the Hacker News Algolia API.
    private lazy var algoliaAPINetworkClient = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        return NetworkClient(
            api: AlgoliaAPI(),
            jsonDecoder: jsonDecoder
        )
    }()

    /// The network client to use for interacting with the Hacker News Firebase API.
    private lazy var firebaseAPINetworkClient = NetworkClient(api: FirebaseAPI())

    /// The array of cached item identifiers from the last visited feed.
    private var cachedIdentifiers: [Int] = []

    /// The current largest item identifier.
    private var maximumItemID: Int?

    /// The service to use to filter items and comments.
    var filterService: FilterServiceProtocol?

    // MARK: Methods

    func item(
        id: Int,
        shouldFetchComments: Bool = false
    ) async throws -> Item {
        let firebaseItemDTO: FirebaseItemDTO = try await perform(
            .get(.item(id: id)),
            with: firebaseAPINetworkClient
        )

        if shouldFetchComments {
            return try await Item(
                algoliaItemDTO: perform(
                    .get(.item(id: id)),
                    with: algoliaAPINetworkClient
                ),
                firebaseItemDTO: firebaseItemDTO,
                filterService: filterService
            )
        } else {
            return Item(firebaseItemDTO: firebaseItemDTO)
        }
    }

    func items(
        in feed: Feed,
        page: Int,
        pageSize: Int,
        resetCache: Bool
    ) async throws -> [Item] {
        let identifiersForPage = Array(
            try await identifiers(
                for: feed,
                resetCache: resetCache
            )
            .dropFirst(pageSize * (page - 1))
            .prefix(pageSize)
        )

        return try await items(for: identifiersForPage)
    }

    func randomStory() async throws -> Item {
        func maximumItemID() async throws -> Int {
            if let maximumItemID = self.maximumItemID {
                return maximumItemID
            } else {
                let maximumItemID: Int = try await perform(
                    .get(.maxitem),
                    with: firebaseAPINetworkClient
                )
                self.maximumItemID = maximumItemID

                return maximumItemID
            }
        }

        let item = try await item(
            id: .random(in: 1 ... maximumItemID()),
            shouldFetchComments: true
        )

        guard let storyId = item.storyId,
              storyId != item.id
        else {
            return item
        }

        return try await self.item(
            id: storyId,
            shouldFetchComments: true
        )
    }

    func search(query: String) async throws -> [Item] {
        let algoliaSearchResponseDTO: AlgoliaSearchResponseDTO = try await perform(
            .get(.search(query: query)),
            with: algoliaAPINetworkClient
        )
        let items = algoliaSearchResponseDTO.hits.map(Item.init)

        return await filterService?.filtered(items: items) ?? items
    }

    func user(id: String) async throws -> User {
        try await User(
            firebaseUserDTO: perform(
                .get(.user(id: id)),
                with: firebaseAPINetworkClient
            )
        )
    }
}

// MARK: - Private extension

private extension HackerNewsService {

    // MARK: Methods

    func items(for identifiers: [Int]) async throws -> [Item] {
        let items = try await identifiers
            .concurrentMap { [self] identifier in
                try? await item(id: identifier)
            }
            .compacted()

        return await filterService?.filtered(items: items) ?? items
    }

    func identifiers(
        for feed: Feed,
        resetCache: Bool
    ) async throws -> [Int] {
        if resetCache {
            cachedIdentifiers = []
        }

        let identifiers: [Int]

        if !cachedIdentifiers.isEmpty {
            identifiers = cachedIdentifiers
        } else {
            identifiers = try await perform(
                .get(.feed(resource: feed.resource)),
                with: firebaseAPINetworkClient
            )
            cachedIdentifiers = identifiers
        }

        return identifiers
    }

    func perform<T: Decodable, API: APIProtocol>(
        _ request: Request<API>,
        with networkClient: NetworkClient<API>
    ) async throws -> T {
        do {
            return try await networkClient.perform(request)
        } catch {
            throw HackerNewsServiceError.network
        }
    }
}
