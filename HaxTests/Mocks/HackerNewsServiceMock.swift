//
//  HackerNewsServiceMock.swift
//  HaxTests
//
//  Created by Luis Fariña on 21/12/22.
//

@testable import Hax

actor HackerNewsServiceMock: HackerNewsServiceProtocol {

    // MARK: Types

    typealias ItemStub = @Sendable (
        _ id: Int,
        _ shouldFetchComments: Bool
    ) -> Item?
    typealias ItemsStub = [Item]
    typealias SearchStub = @Sendable (_ query: String) -> [Item]
    typealias UserStub = User

    // MARK: Properties

    private(set) var itemCallCount = Int.zero
    private(set) var itemsCallCount = Int.zero
    private(set) var searchCallCount = Int.zero
    private(set) var userCallCount = Int.zero
    private var _itemStub: ItemStub?
    private var _itemsStub: ItemsStub?
    private var _searchStub: SearchStub?
    private var _userStub: UserStub?

    // MARK: Methods

    func item(
        id: Int,
        shouldFetchComments: Bool
    ) async throws -> Item {
        itemCallCount += 1

        if let item = _itemStub?(id, shouldFetchComments) {
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

        return try stubOrError(_itemsStub)
    }

    func search(query: String) async throws -> [Item] {
        searchCallCount += 1

        if let items = _searchStub?(query) {
            return items
        } else {
            throw HackerNewsServiceError.network
        }
    }

    func user(id: String) async throws -> User {
        userCallCount += 1

        return try stubOrError(_userStub)
    }

    func itemStub(_ itemStub: ItemStub?) {
        _itemStub = itemStub
    }

    func itemsStub(_ itemsStub: ItemsStub?) {
        _itemsStub = itemsStub
    }

    func searchStub(_ searchStub: SearchStub?) {
        _searchStub = searchStub
    }

    func userStub(_ userStub: UserStub?) {
        _userStub = userStub
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
