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
    ) -> AnyPublisher<[Comment], Error> {
        commentsCallCount += 1

        return publisher(stub: commentsStub)
    }

    func item(id: Int) -> AnyPublisher<Item, Error> {
        itemCallCount += 1

        return publisher(stub: itemStub)
    }

    func items(
        in feed: Feed,
        page: Int,
        pageSize: Int,
        resetCache: Bool
    ) -> AnyPublisher<[Item], Error> {
        itemsCallCount += 1

        return publisher(stub: itemsStub)
    }
}

// MARK: - Private extension

private extension HackerNewsServiceMock {

    // MARK: Methods

    func publisher<T>(stub: T?) -> AnyPublisher<T, Error> {
        guard let stub else {
            return Fail(error: HackerNewsServiceError.network)
                .eraseToAnyPublisher()
        }

        return Just(stub)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
