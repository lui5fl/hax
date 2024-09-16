//
//  UIDeviceExtension.swift
//  Hax
//
//  Created by Luis Fariña on 16/9/24.
//

#if DEBUG

import UIKit

extension UIDevice {

    // MARK: Properties

    static let deviceDidShake = Notification.Name(
        rawValue: "deviceDidShake"
    )
}

#endif
