//
//  HackerNewsServiceMock.swift
//  HaxTests
//
//  Created by Luis Fariña on 21/12/22.
//

import Combine
@testable import Hax

final class HackerNewsServiceMock: HackerNewsServiceProtocol {

    // MARK: Properties

    var commentsStub: [Comment]?
    var itemStub: Item?
    var itemsStub: [Item]?
    private(set) var commentsCallCount = 0
    private(set) var itemCallCount = 0
    private(set) var itemsCallCount = 0

    // MARK: Methods

    func comments(
        in item: Item,
        page: Int,
        pageSize: Int
    ) async throws -> [Comment] {
        commentsCallCount += 1

        return try stubOrError(commentsStub)
    }

    func item(id: Int) async throws -> Item {
        itemCallCount += 1

        return try stubOrError(itemStub)
    }

    func items(
        in feed: Feed,
        page: Int,
        pageSize: Int,
        resetCache: Bool
    ) async throws -> [Item] {
        itemsCallCount += 1

        return try stubOrError(itemsStub)
    }
}

// MARK: - Private extension

private extension HackerNewsServiceMock {

    // MARK: Methods

    func stubOrError<T>(_ stub: T?) throws -> T {
        guard let stub else {
            throw HackerNewsServiceError.network
        }

        return stub
    }
}
