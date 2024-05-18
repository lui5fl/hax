//
//  AppVersionService.swift
//  Hax
//
//  Created by Luis Fariña on 20/12/22.
//

import Foundation

protocol AppVersionServiceProtocol {

    // MARK: Methods

    /// Returns the app version.
    func appVersion() -> String?
}

struct AppVersionService: AppVersionServiceProtocol {

    // MARK: Properties

    private let bundle: Bundle

    // MARK: Initialization

    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    // MARK: Methods

    func appVersion() -> String? {
        guard let version = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
              let build = bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String
        else {
            return nil
        }

        return "\(version) (\(build))"
    }
}
