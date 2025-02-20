//
//  UIWindowExtension.swift
//  Hax
//
//  Created by Luis Fariña on 16/9/24.
//

#if DEBUG

import UIKit

extension UIWindow {

    // MARK: Methods

    open override func motionEnded(
        _ motion: UIEvent.EventSubtype,
        with: UIEvent?
    ) {
        guard motion == .motionShake else {
            return
        }

        NotificationCenter.default.post(
            name: UIDevice.deviceDidShake,
            object: nil
        )
    }
}

#endif
