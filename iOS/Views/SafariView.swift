//
//  SafariView.swift
//  Hax (iOS)
//
//  Created by Luis Fariña on 9/5/22.
//

import SafariServices
import SwiftUI

struct SafariView: UIViewControllerRepresentable {

    // MARK: Properties

    let url: URL

    // MARK: UIViewControllerRepresentable

    func makeUIViewController(
        context: Context
    ) -> SFSafariViewController {
        let controller = SFSafariViewController(url: url)
        controller.preferredControlTintColor = .tintColor

        return controller
    }

    func updateUIViewController(
        _ uiViewController: SFSafariViewController,
        context: Context
    ) {
        // Do nothing
    }
}
