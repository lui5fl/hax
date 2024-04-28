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
                    if let itemID = RegexService().itemID(url: url) {
                        mainViewModel.presentedItem = Item(id: itemID)
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
