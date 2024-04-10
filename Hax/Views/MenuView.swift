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
    @Binding private(set) var selectedFeed: Feed?
    @Binding private(set) var presentedItem: Item?

    // MARK: Body

    var body: some View {
        List(selection: $selectedFeed) {
            Section {
                ForEach(model.feeds) { feed in
                    NavigationLink(value: feed) {
                        Label(
                            feed.title,
                            systemImage: feed.systemImage
                        )
                    }
                }
            }
            Section {
                Button {
                    model.openHackerNewsLinkAlertIsPresented = true
                } label: {
                    Label(
                        "Open Hacker News Link",
                        systemImage: "link"
                    )
                }
                NavigationLink {
                    SettingsView(model: SettingsViewModel())
                } label: {
                    Label("Settings", systemImage: "gearshape")
                }
            }
        }
        .alert(error: $model.error)
        .alert(
            "Open Hacker News Link",
            isPresented: $model.openHackerNewsLinkAlertIsPresented
        ) {
            TextField(
                String(""),
                text: $model.openHackerNewsLinkAlertText
            )
            Button("Cancel") {
                model.openHackerNewsLinkAlertText = ""
            }
            Button("OK") {
                presentedItem = model.itemForHackerNewsLink()
            }
            .keyboardShortcut(.defaultAction)
        } message: {
            Text("Input a valid Hacker News link into the text field.")
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Feeds")
    }
}

// MARK: - Previews

#Preview {
    NavigationStack {
        MenuView(
            model: MenuViewModel(),
            selectedFeed: .constant(nil),
            presentedItem: .constant(nil)
        )
    }
}
