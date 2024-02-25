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
    @State private var columnVisibility = NavigationSplitViewVisibility.all

    // MARK: Body

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            MenuView(
                model: MenuViewModel(),
                selectedFeed: $model.selectedFeed
            )
        } content: {
            if let feed = model.selectedFeed {
                FeedView(
                    model: FeedViewModel(feed: feed),
                    selectedItem: $model.selectedItem
                )
            } else {
                Text("Select a feed")
                    .foregroundStyle(.secondary)
            }
        } detail: {
            if let item = model.selectedItem {
                ItemView(model: ItemViewModel(item: item))
            } else {
                Text("Select an item")
                    .foregroundStyle(.secondary)
            }
        }
        .onChange(of: model.selectedItem) {
            columnVisibility = model.selectedItem != nil ? .doubleColumn : .automatic
        }
    }
}

// MARK: - Previews

#Preview {
    MainView(model: MainViewModel())
}
