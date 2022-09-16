//
//  SettingsViewModel.swift
//  Hax
//
//  Created by Luis Fariña on 26/5/22.
//

import SwiftUI

@MainActor final class SettingsViewModel: ObservableObject {

    // MARK: Properties

    /// The feed set as default by the user.
    @AppStorage(UserDefaults.Key.defaultFeed) var defaultFeed: Feed?

    /// The URL to navigate to.
    @Published var url: IdentifiableURL?

    /// The array of feeds to display in the default feed picker.
    let feeds = Feed.allCases

    /// The string to display in the "Version" row.
    let version: String?

    // MARK: Initialization

    init() {
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
           let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String {
            self.version = "\(version) (\(build))"
        } else {
            self.version = nil
        }
    }

    // MARK: Methods

    /// Publishes the URL corresponding to the privacy policy.
    func presentPrivacyPolicy() {
        url = IdentifiableURL(
            URL(string: "https://luisfl.me/hax/privacy-policy")
        )
    }
}
