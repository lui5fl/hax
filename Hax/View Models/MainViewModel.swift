//
//  MainViewModel.swift
//  Hax
//
//  Created by Luis Fariña on 2/3/24.
//

import Foundation

@MainActor
protocol MainViewModelProtocol {

    // MARK: Properties

    /// The selected feed.
    var selectedFeed: Feed? { get set }

    /// The selected item.
    var selectedItem: Item? { get set }

    /// The presented item.
    var presentedItem: Item? { get set }
}

@Observable
final class MainViewModel: MainViewModelProtocol {

    // MARK: Properties

    var selectedFeed: Feed?
    var selectedItem: Item?
    var presentedItem: Item?

    // MARK: Initialization

    init(defaultFeedService: some DefaultFeedServiceProtocol = DefaultFeedService()) {
        selectedFeed = defaultFeedService.defaultFeed()
    }
}
