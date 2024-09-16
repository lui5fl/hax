//
//  DebugViewExtension.swift
//  Hax
//
//  Created by Luis Fariña on 11/2/25.
//

#if DEBUG

import SwiftUI

extension View {

    // MARK: Methods

    /// Attaches an action to be performed when the device shake gesture is detected.
    ///
    /// - Parameters:
    ///   - action: The closure to be executed when the shake gesture is recognized
    func onShake(perform action: @escaping () -> Void) -> some View {
        onReceive(
            NotificationCenter.default.publisher(
                for: UIDevice.deviceDidShake
            )
        ) { _ in
            action()
        }
    }
}

#endif
