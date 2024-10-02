//
//  FeedViewModel.swift
//  HaxWatch
//
//  Created by Luis Fariña on 24/9/24.
//

import Foundation

@MainActor
@Observable
class FeedViewModel {

    // MARK: Types

    enum State {

        // MARK: Cases

        case error(Error)
        case loaded(items: [Item])
        case loading
    }

    // MARK: Properties

    let feed: Feed
    var state = State.loading

    // MARK: Initialization

    init(feed: Feed) {
        self.feed = feed
    }

    // MARK: Methods

    func onAppear() async {
        do {
            state = .loaded(
                items: try await HackerNewsService.shared.items(
                    in: feed,
                    page: 1,
                    pageSize: 10,
                    resetCache: true
                )
            )
        } catch {
            state = .error(error)
        }
    }
}
