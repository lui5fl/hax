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
    func item(id: Int) async throws -> Item

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

    /// The service to use to filter items and comments.
    var filterService: FilterServiceProtocol?

    // MARK: Methods

    func item(id: Int) async throws -> Item {
        try await Item(
            algoliaItemDTO: perform(
                .get(.item(id: id)),
                with: algoliaAPINetworkClient
            ),
            firebaseItemDTO: perform(
                .get(.item(id: id)),
                with: firebaseAPINetworkClient
            ),
            filterService: filterService
        )
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
}

// MARK: - Private extension

private extension HackerNewsService {

    // MARK: Methods

    func items(for identifiers: [Int]) async throws -> [Item] {
        let items = try await identifiers
            .concurrentMap { [self] identifier in
                try? await Item(
                    firebaseItemDTO: perform(
                        .get(.item(id: identifier)),
                        with: firebaseAPINetworkClient
                    )
                )
            }
            .compacted()

        return filterService?.filtered(items: items) ?? items
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
