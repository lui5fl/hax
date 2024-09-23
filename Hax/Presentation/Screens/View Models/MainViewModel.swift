//
//  MainViewModel.swift
//  Hax
//
//  Created by Luis Fariña on 2/3/24.
//

import Foundation

enum Tab {

    // MARK: Cases

    case home, search, settings
}

@MainActor
protocol MainViewModelProtocol {

    // MARK: Properties

    /// The selected tab.
    var selectedTab: Tab { get set }

    /// The selected feed.
    var selectedFeed: Feed? { get set }

    /// The selected item.
    var selectedItem: Item? { get set }

    /// The presented item.
    var presentedItem: Item? { get set }

    /// The presented user.
    var presentedUser: IdentifiableString? { get set }
}

@Observable
final class MainViewModel: MainViewModelProtocol {

    // MARK: Properties

    var selectedTab = Tab.home
    var selectedFeed: Feed?
    var selectedItem: Item?
    var presentedItem: Item?
    var presentedUser: IdentifiableString?
    private let haxWCSessionDelegate = HaxWCSessionDelegate()

    // MARK: Initialization

    init(defaultFeedService: some DefaultFeedServiceProtocol = DefaultFeedService()) {
        selectedFeed = defaultFeedService.defaultFeed()
        haxWCSessionDelegate.didReceiveApplicationContext = { [weak self] applicationContext in
            guard
                let self,
                let id = applicationContext["id"] as? Int
            else {
                return
            }

            Task { @MainActor in
                presentedItem = Item(id: id)
            }
        }
    }
}
