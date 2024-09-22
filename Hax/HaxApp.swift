//
//  HaxApp.swift
//  Hax
//
//  Created by Luis Fariña on 8/5/22.
//

import SwiftUI

@MainActor
@main
struct HaxApp: App {

    // MARK: Properties

    @State private var mainViewModel = MainViewModel()
    @AppStorage(UserDefaults.Key.url) private var urlString: String?

    @AppStorage(UserDefaults.Key.numberOfLaunches)
    private var numberOfLaunches = Int.zero

    // MARK: Initialization

    init() {
        numberOfLaunches += 1
    }

    // MARK: Body

    var body: some Scene {
        WindowGroup {
            MainView(model: mainViewModel)
                .onContinueUserActivity(
                    Constant.readItemUserActivity
                ) { userActivity in
                    if let id = userActivity.userInfo?["id"] as? Int {
                        mainViewModel.presentedItem = Item(id: id)
                    }
                }
                .onOpenURL(perform: handleURL)
        }
        .modelContainer(
            for: [KeywordFilter.self, UserFilter.self]
        ) { result in
            Task {
                await HackerNewsService.shared.setFilterService(
                    try? FilterService(modelContainer: result.get())
                )
            }
        }
        .onChange(of: urlString) { _, _ in
            guard let urlString,
                  let url = URL(string: urlString)
            else {
                return
            }

            self.urlString = nil
            handleURL(url)
        }
    }
}

// MARK: - Private extension

private extension HaxApp {

    // MARK: Methods

    func handleURL(_ url: URL?) {
        guard let url else {
            return
        }

        let regexService = RegexService()

        if let feed = regexService.feed(url: url) {
            mainViewModel.selectedTab = .home
            mainViewModel.selectedFeed = feed
            mainViewModel.selectedItem = nil
            mainViewModel.presentedItem = nil
            mainViewModel.presentedUser = nil
        } else if let itemID = regexService.itemID(url: url) {
            mainViewModel.presentedItem = Item(id: itemID)
            mainViewModel.presentedUser = nil
        } else if let userID = regexService.userID(url: url) {
            mainViewModel.presentedItem = nil
            mainViewModel.presentedUser = IdentifiableString(userID)
        }
    }
}
