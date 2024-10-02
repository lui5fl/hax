//
//  MenuView.swift
//  HaxWatch
//
//  Created by Luis Fariña on 24/9/24.
//

import SwiftUI

struct MenuView: View {

    // MARK: Properties

    @Binding var selectedFeed: Feed?

    // MARK: Body

    var body: some View {
        List(Feed.allCases, selection: $selectedFeed) { feed in
            NavigationLink(value: feed) {
                Label(feed.title, systemImage: feed.systemImage)
            }
        }
        .containerBackground(
            Color.accentColor.gradient,
            for: .navigation
        )
        .navigationTitle("Feeds")
    }
}

// MARK: - Previews

#Preview {
    NavigationStack {
        MenuView(selectedFeed: .constant(nil))
    }
}
