//
//  HaxApp.swift
//  Hax
//
//  Created by Luis Fariña on 8/5/22.
//

import SwiftUI

@main
struct HaxApp: App {

    var body: some Scene {
        WindowGroup {
            MenuView(model: MenuViewModel())
        }
    }
}
