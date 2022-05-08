//
//  FeedViewModel.swift
//  Hax
//
//  Created by Luis Fariña on 8/5/22.
//

import Combine
import UIKit

@MainActor class FeedViewModel: ObservableObject {

    // MARK: Properties

    /// Whether the view model is fetching items or not.
    @Published var isLoading = true

    /// The error to display in the view.
    @Published var error: Error?

    /// The array of items to display in the list.
    @Published var items: [Item] = []

    /// The selected item.
    @Published var item: Item?

    /// The URL to navigate to.
    @Published var url: IdentifiableURL?

    /// The feed whose items are to be fetched.
    let feed: Feed

    /// Whether it is the first time the view model is fetching items or not.
    private var isFirstTimeFetchingItems = true

    /// The page of items to be fetched.
    private var page = 1

    /// The subscriber to the request of items.
    private var cancellable: AnyCancellable?

    // MARK: Initialization

    init(feed: Feed) {
        self.feed = feed
    }

    // MARK: Methods

    /// Fetches the items in the feed for the first time.
    func fetchItems() {
        guard isFirstTimeFetchingItems else {
            return
        }

        isFirstTimeFetchingItems = false
        fetchItems(resetCache: true)
    }

    /// Fetches the next page of items in the feed.
    func fetchMoreItems() {
        page += 1
        fetchItems(resetCache: false)
    }

    /// Pushes an item view for the item.
    func pushItemView(for item: Item) {
        self.item = item
    }

    /// Either presents Safari or pushes an item view depending on the properties of the item.
    func select(item: Item) {
        if let url = item.url {
            self.url = IdentifiableURL(url)
        } else {
            pushItemView(for: item)
        }
    }

    /// Opens up a share sheet to share the URL of the item if it has one.
    func share(item: Item) {
        guard let url = item.url else {
            return
        }

        UIActivityViewController.present(sharing: url)
    }
}

// MARK: - Private extension

private extension FeedViewModel {

    /// Fetches the current page of items in the feed.
    ///
    /// - Parameters:
    ///   - resetCache: Whether the cache of item identifiers should be cleared or not
    func fetchItems(resetCache: Bool) {
        cancellable = HackerNewsService.shared.items(
            in: feed,
            page: page,
            resetCache: resetCache
        )
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.error = error
                    }
                },
                receiveValue: { [weak self] value in
                    self?.items += value
                }
            )
    }
}
