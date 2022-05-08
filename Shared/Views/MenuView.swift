//
//  MenuView.swift
//  Hax
//
//  Created by Luis Fariña on 8/5/22.
//

import SwiftUI

struct MenuView: View {

    // MARK: Properties

    @StateObject private var viewModel = MenuViewModel()

    // MARK: Body

    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(viewModel.feeds, id: \.self) { feed in
                        NavigationLink(
                            tag: feed,
                            selection: $viewModel.feed
                        ) {
                            FeedView(
                                viewModel: FeedViewModel(feed: feed)
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
                        SettingsView()
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
        Preview {
            MenuView()
        }
    }
}
