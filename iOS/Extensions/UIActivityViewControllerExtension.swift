//
//  UIActivityViewControllerExtension.swift
//  Hax (iOS)
//
//  Created by Luis Fariña on 23/5/22.
//

import UIKit

extension UIActivityViewController {

    /// Presents an instance of `UIActivityViewController` to share a specific URL.
    ///
    /// - Parameters:
    ///   - url: The URL to share
    class func present(sharing url: URL) {
        let controller = UIActivityViewController(
            activityItems: [url],
            applicationActivities: nil
        )
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let rootViewController = windowScene?.windows.first?.rootViewController

        rootViewController?.present(controller, animated: true)
    }
}
