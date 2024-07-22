//
//  FeedViewModel.swift
//  Hax
//
//  Created by Luis Fariña on 8/5/22.
//

import UIKit
import WidgetKit

@MainActor
protocol FeedViewModelProtocol: ObservableObject {

    // MARK: Properties

    /// The feed whose items are to be fetched.
    var feed: Feed { get }

    /// Whether the view model is fetching items.
    var isLoading: Bool { get }

    /// The error to display in the view.
    var error: Error? { get set }

    /// The array of items to display in the list.
    var items: [Item] { get }

    /// The URL to navigate to.
    var url: IdentifiableURL? { get set }

    // MARK: Methods

    /// Called when the view appears.
    func onViewAppear() async

    /// Called when an item appears.
    func onItemAppear(item: Item) async

    /// Called when the user requests a refresh.
    func onRefreshRequest() async
}

class FeedViewModel: FeedViewModelProtocol {

    // MARK: Properties

    let feed: Feed
    @Published var isLoading = true
    @Published var error: Error?
    @Published var items: [Item] = []
    @Published var url: IdentifiableURL?

    /// The service to use for fetching Hacker News data.
    private let hackerNewsService: HackerNewsServiceProtocol

    /// Whether it is the first time the view model is fetching items.
    private var isFirstTimeFetchingItems = true

    /// The page of items to be fetched.
    private var page = Constant.initialPage

    // MARK: Initialization

    init(
        feed: Feed,
        hackerNewsService: HackerNewsServiceProtocol = HackerNewsService.shared
    ) {
        self.feed = feed
        self.hackerNewsService = hackerNewsService
    }

    // MARK: Methods

    func onViewAppear() async {
        guard isFirstTimeFetchingItems else {
            return
        }

        isFirstTimeFetchingItems = false
        await fetchItems(resetCache: true)
    }

    func onItemAppear(item: Item) async {
        guard item == items.last else {
            return
        }

        page += 1
        await fetchItems(resetCache: false)
    }

    func onRefreshRequest() async {
        await fetchItems(resetCache: true)
    }
}

// MARK: - Private extension

private extension FeedViewModel {

    // MARK: Types

    enum Constant {
        static let initialPage = 1
    }

    // MARK: Methods

    /// Fetches the current page of items in the feed.
    ///
    /// - Parameters:
    ///   - resetCache: Whether the cached items should be cleared
    func fetchItems(resetCache: Bool) async {
        do {
            if resetCache {
                page = Constant.initialPage
            }
            let items = try await hackerNewsService.items(
                in: feed,
                page: page,
                pageSize: 10,
                resetCache: resetCache
            )
            if resetCache {
                self.items = items
                WidgetCenter.shared.reloadAllTimelines()
            } else {
                self.items += items
            }
        } catch {
            self.error = error
        }

        isLoading = false
    }
}
