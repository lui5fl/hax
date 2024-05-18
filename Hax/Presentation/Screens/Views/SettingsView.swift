//
//  SettingsView.swift
//  Hax
//
//  Created by Luis Fariña on 23/5/22.
//

import SwiftUI

struct SettingsView<Model: SettingsViewModelProtocol>: View {

    // MARK: Properties

    @StateObject var model: Model

    // MARK: Body

    var body: some View {
        Form {
            Section {
                Picker(selection: $model.defaultFeed) {
                    Text("None")
                        .tag(nil as Feed?)
                    ForEach(model.feeds, id: \.self) { feed in
                        Text(feed.title)
                            .tag(feed as Feed?)
                    }
                } label: {
                    Text("Default Feed")
                }
                NavigationLink {
                    FilterView()
                } label: {
                    Label("Filters", systemImage: "eye.slash")
                }
            }
            Section("About") {
                Button("Privacy Policy") {
                    model.onPrivacyPolicyButtonTrigger()
                }
                if let version = model.version {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(verbatim: version)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Settings")
        .safari(url: $model.url)
    }
}

// MARK: - Previews

struct SettingsView_Previews: PreviewProvider {

    static var previews: some View {
        NavigationStack {
            SettingsView(model: SettingsViewModel())
        }
    }
}
