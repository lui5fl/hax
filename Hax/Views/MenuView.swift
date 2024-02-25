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
                NavigationLink {
                    SettingsView(model: SettingsViewModel())
                } label: {
                    Label("Settings", systemImage: "gearshape")
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Feeds")
        .sheet(isPresented: $model.settingsViewIsPresented) {
            SettingsView(model: SettingsViewModel())
                .dismissable(isPresented: $model.settingsViewIsPresented)
        }
        .toolbar {
            Button {
                model.settingsViewIsPresented = true
            } label: {
                Label("Settings", systemImage: "gearshape")
            }
        }
    }
}

// MARK: - Previews

#Preview {
    NavigationStack {
        MenuView(
            model: MenuViewModel(),
            selectedFeed: .constant(nil)
        )
    }
}
