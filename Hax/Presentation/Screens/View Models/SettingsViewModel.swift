//
//  SettingsViewModel.swift
//  Hax
//
//  Created by Luis Fariña on 26/5/22.
//

import SwiftUI

@MainActor
protocol SettingsViewModelProtocol: ObservableObject {

    // MARK: Properties

    /// The array of feeds to display in the default feed picker.
    var feeds: [Feed] { get }

    /// The string to display in the "Version" row.
    var version: String? { get }

    /// The feed set as default by the user.
    var defaultFeed: Feed? { get set }

    /// The URL to navigate to.
    var url: IdentifiableURL? { get set }

    // MARK: Methods

    /// Called when the "Safari Extension" button is triggered.
    func onSafariExtensionButtonTrigger()

    /// Called when the "Privacy Policy" button is triggered.
    func onPrivacyPolicyButtonTrigger()
}

final class SettingsViewModel: SettingsViewModelProtocol {

    // MARK: Properties

    let feeds = Feed.allCases
    let version: String?
    @AppStorage(UserDefaults.Key.defaultFeed) var defaultFeed: Feed?
    @Published var url: IdentifiableURL?

    // MARK: Initialization

    init(appVersionService: some AppVersionServiceProtocol = AppVersionService()) {
        version = appVersionService.appVersion()
    }

    // MARK: Methods

    func onSafariExtensionButtonTrigger() {
        url = IdentifiableURL(URL(string: "https://luisfl.me/hax/help/safari-extension"))
    }

    func onPrivacyPolicyButtonTrigger() {
        url = IdentifiableURL(URL(string: "https://luisfl.me/hax/privacy-policy"))
    }
}
