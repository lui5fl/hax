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
    @Binding private(set) var presentedUser: IdentifiableString?

    // MARK: Body

    var body: some View {
        List(selection: $selectedFeed) {
            Section("Feeds") {
                ForEach(model.feeds) { feed in
                    NavigationLink(value: feed) {
                        Label(
                            feed.title,
                            systemImage: feed.systemImage
                        )
                    }
                }
            }
            Section("Other") {
                Button {
                    model.openHackerNewsLinkAlertIsPresented = true
                } label: {
                    Label(
                        "Open Hacker News Link",
                        systemImage: "link"
                    )
                }
                Button {
                    model.viewUserAlertIsPresented = true
                } label: {
                    Label(
                        "View User",
                        systemImage: "person"
                    )
                }
            }
        }
        .alert(error: $model.error)
        .listStyle(.insetGrouped)
        .navigationTitle("Home")
        .textFieldAlert(
            "Open Hacker News Link",
            message: "Input a valid Hacker News link into the text field.",
            isPresented: $model.openHackerNewsLinkAlertIsPresented,
            text: $model.openHackerNewsLinkAlertText
        ) { _ in
            presentedItem = model.itemForHackerNewsLink()
        }
        .textFieldAlert(
            "View User",
            message: "Input a Hacker News username into the text field.",
            isPresented: $model.viewUserAlertIsPresented,
            text: $model.viewUserAlertText
        ) { user in
            if !user.isEmpty {
                presentedUser = IdentifiableString(user)
            }
        }
    }
}

// MARK: - Previews

#Preview {
    NavigationStack {
        MenuView(
            model: MenuViewModel(),
            selectedFeed: .constant(nil),
            presentedItem: .constant(nil),
            presentedUser: .constant(nil)
        )
    }
}
