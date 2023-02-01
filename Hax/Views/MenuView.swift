//
//  MenuView.swift
//  Hax
//
//  Created by Luis Fariña on 8/5/22.
//

import SwiftUI

struct MenuView<Model: MenuViewModelProtocol>: View {

    // MARK: Properties

    @StateObject var model: Model

    // MARK: Body

    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(model.feeds, id: \.self) { feed in
                        NavigationLink(
                            tag: feed,
                            selection: $model.selectedFeed
                        ) {
                            FeedView(
                                model: FeedViewModel(feed: feed)
                            )
                        } label: {
                            Label(
                                feed.title,
                                systemImage: feed.systemImage
                            )
                        }
                    }
                }
                Section {
                    NavigationLink {
                        SettingsView(model: SettingsViewModel())
                    } label: {
                        Label("Settings", systemImage: "gearshape")
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Feeds")
        }
    }
}

// MARK: - Previews

struct MenuView_Previews: PreviewProvider {

    static var previews: some View {
        MenuView(model: MenuViewModel())
    }
}
