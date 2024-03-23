//
//  MainView.swift
//  Hax
//
//  Created by Luis Fariña on 2/3/24.
//

import SwiftUI

struct MainView<Model: MainViewModelProtocol>: View {

    // MARK: Properties

    @StateObject var model: Model

    // MARK: Body

    var body: some View {
        NavigationStack {
            MenuView(
                model: MenuViewModel(),
                selectedFeed: $model.selectedFeed,
                presentedItem: $model.presentedItem
            )
            .navigationDestination(item: $model.selectedFeed) { feed in
                FeedView(
                    model: FeedViewModel(feed: feed),
                    selectedItem: $model.selectedItem
                )
                .navigationDestination(item: $model.selectedItem) { item in
                    ItemView(model: ItemViewModel(item: item))
                }
            }
        }
        .fullScreenCover(item: $model.presentedItem) { item in
            ItemView(model: ItemViewModel(item: item))
                .dismissable(item: $model.presentedItem)
        }
    }
}

// MARK: - Previews

#Preview {
    MainView(model: MainViewModel())
}
