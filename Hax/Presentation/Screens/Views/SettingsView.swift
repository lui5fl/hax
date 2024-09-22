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
    @Binding var navigationPath: NavigationPath

    // MARK: Body

    var body: some View {
        Form {
            Section("General") {
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
                NavigationLink(
                    value: NavigationDestination.filters
                ) {
                    Label("Filters", systemImage: "eye.slash")
                }
            }
            Section("Help") {
                Button("Safari Extension") {
                    model.onSafariExtensionButtonTrigger()
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
        .navigationDestination(
            for: NavigationDestination.self
        ) { navigationDestination in
            switch navigationDestination {
            case .filters:
                FilterView()
            }
        }
        .navigationTitle("Settings")
        .safari(url: $model.url)
    }
}

// MARK: - Private extension

private extension SettingsView {

    // MARK: Types

    enum NavigationDestination {

        // MARK: Cases

        case filters
    }
}

// MARK: - Previews

#Preview {
    NavigationStack {
        SettingsView(
            model: SettingsViewModel(),
            navigationPath: .constant(NavigationPath())
        )
    }
}
