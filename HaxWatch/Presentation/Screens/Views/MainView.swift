//
//  MainView.swift
//  HaxWatch
//
//  Created by Luis Fariña on 24/9/24.
//

import SwiftUI

struct MainView: View {

    // MARK: Properties

    @State private var selectedFeed: Feed?

    // MARK: Body

    var body: some View {
        NavigationStack {
            MenuView(selectedFeed: $selectedFeed)
                .navigationDestination(item: $selectedFeed) { feed in
                    FeedView(model: FeedViewModel(feed: feed))
                }
        }
    }
}

// MARK: - Previews

#Preview {
    MainView()
}
