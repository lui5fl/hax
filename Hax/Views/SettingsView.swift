//
//  SettingsView.swift
//  Hax
//
//  Created by Luis Fariña on 23/5/22.
//

import SwiftUI

struct SettingsView: View {

    // MARK: Properties

    @StateObject private var viewModel = SettingsViewModel()

    // MARK: Body

    var body: some View {
        Form {
            Section {
                Picker(selection: $viewModel.defaultFeed) {
                    Text("None")
                        .tag(nil as Feed?)
                    ForEach(viewModel.feeds, id: \.self) { feed in
                        Text(feed.title)
                            .tag(feed as Feed?)
                    }
                } label: {
                    Text("Default Feed")
                }
            }
            Section("About") {
                Button("Privacy Policy") {
                    viewModel.presentPrivacyPolicy()
                }
                if let version = viewModel.version {
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
        .safari(url: $viewModel.url)
    }
}

// MARK: - Previews

struct SettingsView_Previews: PreviewProvider {

    static var previews: some View {
        NavigationView {
            SettingsView()
        }
    }
}
