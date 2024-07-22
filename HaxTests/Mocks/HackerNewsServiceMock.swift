//
//  HackerNewsServiceMock.swift
//  HaxTests
//
//  Created by Luis Fariña on 21/12/22.
//

@testable import Hax

final class HackerNewsServiceMock: HackerNewsServiceProtocol {

    // MARK: Properties

    var itemStub: (
        (_ id: Int, _ shouldFetchComments: Bool) -> Item?
    )?
    var itemsStub: [Item]?
    var userStub: User?

    private(set) var itemCallCount = Int.zero
    private(set) var itemsCallCount = Int.zero
    private(set) var userCallCount = Int.zero

    // MARK: Methods

    func item(
        id: Int,
        shouldFetchComments: Bool
    ) async throws -> Item {
        itemCallCount += 1

        if let item = itemStub?(id, shouldFetchComments) {
            return item
        } else {
            throw HackerNewsServiceError.network
        }
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

    func user(id: String) async throws -> User {
        userCallCount += 1

        return try stubOrError(userStub)
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
