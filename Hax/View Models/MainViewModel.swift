//
//  MainViewModel.swift
//  Hax
//
//  Created by Luis Fariña on 2/3/24.
//

import Foundation

@MainActor
protocol MainViewModelProtocol: ObservableObject {

    // MARK: Properties

    /// The selected feed.
    var selectedFeed: Feed? { get set }

    /// The selected item.
    var selectedItem: Item? { get set }
}

final class MainViewModel: MainViewModelProtocol {

    // MARK: Properties

    @Published var selectedFeed: Feed?
    @Published var selectedItem: Item?

    // MARK: Initialization

    init(defaultFeedService: some DefaultFeedServiceProtocol = DefaultFeedService()) {
        selectedFeed = defaultFeedService.defaultFeed()
    }
}
