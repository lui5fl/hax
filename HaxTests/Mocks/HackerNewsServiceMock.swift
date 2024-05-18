//
//  HackerNewsServiceMock.swift
//  HaxTests
//
//  Created by Luis Fariña on 21/12/22.
//

@testable import Hax

final class HackerNewsServiceMock: HackerNewsServiceProtocol {

    // MARK: Properties

    var itemStub: Item?
    var itemsStub: [Item]?

    private(set) var itemCallCount = Int.zero
    private(set) var itemsCallCount = Int.zero

    // MARK: Methods

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
