//
//  MainView.swift
//  Hax
//
//  Created by Luis Fariña on 2/3/24.
//

import SwiftUI

struct MainView<Model: MainViewModelProtocol>: View {

    // MARK: Properties

    @State var model: Model

    // MARK: Body

    var body: some View {
        NavigationStack {
            MenuView(
                model: MenuViewModel(),
                selectedFeed: $model.selectedFeed,
                presentedItem: $model.presentedItem,
                presentedUser: $model.presentedUser
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
                .id(item)
        }
        .sheet(item: $model.presentedUser) { user in
            UserView(model: UserViewModel(id: user.string))
                .presentationDetents([.medium, .large])
                .id(user.string)
        }
    }
}

// MARK: - Previews

#Preview {
    MainView(model: MainViewModel())
}
