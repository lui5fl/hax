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

    // MARK: Body

    var body: some Scene {
        WindowGroup {
            MainView(model: mainViewModel)
                .onOpenURL { url in
                    let regexService = RegexService()

                    if let itemID = regexService.itemID(url: url) {
                        mainViewModel.presentedItem = Item(id: itemID)
                    } else if let userID = regexService.userID(url: url) {
                        mainViewModel.presentedUser = IdentifiableString(userID)
                    }
                }
        }
        .modelContainer(
            for: [KeywordFilter.self, UserFilter.self]
        ) { result in
            HackerNewsService.shared.filterService = (try? result.get().mainContext).map {
                FilterService(modelContext: $0)
            }
        }
    }
}
