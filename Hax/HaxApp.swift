//
//  HaxApp.swift
//  Hax
//
//  Created by Luis Fariña on 8/5/22.
//

import SwiftUI

@main
struct HaxApp: App {

    // MARK: Body

    var body: some Scene {
        WindowGroup {
            MainView(model: MainViewModel())
        }
    }
}
