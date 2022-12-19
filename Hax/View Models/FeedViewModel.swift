//
//  FeedViewModel.swift
//  Hax
//
//  Created by Luis Fariña on 8/5/22.
//

import Combine
import UIKit

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

    /// The selected item.
    var selectedItem: Item? { get set }

    /// The URL to navigate to.
    var url: IdentifiableURL? { get set }

    // MARK: Methods

    /// Called when the view appears.
    func onViewAppear()

    /// Called when an item appears.
    func onItemAppear(item: Item)

    /// Called when the button of an item is triggered.
    func onItemButtonTrigger(item: Item)

    /// Called when the number of comments of an item is tapped.
    func onNumberOfCommentsTap(item: Item)
}

class FeedViewModel: FeedViewModelProtocol {

    // MARK: Properties

    let feed: Feed
    @Published var isLoading = true
    @Published var error: Error?
    @Published var items: [Item] = []
    @Published var selectedItem: Item?
    @Published var url: IdentifiableURL?

    /// The service to use for fetching Hacker News data.
    private let hackerNewsService: HackerNewsServiceProtocol

    /// Whether it is the first time the view model is fetching items.
    private var isFirstTimeFetchingItems = true

    /// The page of items to be fetched.
    private var page = 1

    /// The subscriber to the request of items.
    private var cancellable: AnyCancellable?

    // MARK: Initialization

    init(
        feed: Feed,
        hackerNewsService: HackerNewsServiceProtocol = HackerNewsService.shared
    ) {
        self.feed = feed
        self.hackerNewsService = hackerNewsService
    }

    // MARK: Methods

    func onViewAppear() {
        guard isFirstTimeFetchingItems else {
            return
        }

        isFirstTimeFetchingItems = false
        fetchItems(resetCache: true)
    }

    func onItemAppear(item: Item) {
        guard item == items.last else {
            return
        }

        page += 1
        fetchItems(resetCache: false)
    }

    func onItemButtonTrigger(item: Item) {
        if let url = item.url {
            self.url = IdentifiableURL(url)
        } else {
            onNumberOfCommentsTap(item: item)
        }
    }

    func onNumberOfCommentsTap(item: Item) {
        selectedItem = item
    }
}

// MARK: - Private extension

private extension FeedViewModel {

    /// Fetches the current page of items in the feed.
    ///
    /// - Parameters:
    ///   - resetCache: Whether the cache of item identifiers should be cleared
    func fetchItems(resetCache: Bool) {
        cancellable = hackerNewsService.items(
            in: feed,
            page: page,
            pageSize: 10,
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
