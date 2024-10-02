//
//  HaxWatchApp.swift
//  HaxWatch
//
//  Created by Luis Fariña on 23/9/24.
//

import SwiftUI

@main
struct HaxWatchApp: App {

    // MARK: Properties

    private let haxWCSessionDelegate = HaxWCSessionDelegate()

    // MARK: Body

    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
