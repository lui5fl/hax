//
//  ShareView.swift
//  Hax
//
//  Created by Luis Fariña on 7/4/24.
//

import SwiftUI

struct ShareView: View {

    // MARK: Properties

    let url: URL?
    let hackerNewsURL: URL?

    // MARK: Body

    var body: some View {
        if let url {
            if let hackerNewsURL {
                Menu("Share…", systemImage: "square.and.arrow.up") {
                    ShareLink(item: url) {
                        Text("Story Link")
                    }
                    ShareLink(item: hackerNewsURL) {
                        Text("Hacker News Link")
                    }
                }
            } else {
                ShareLink(item: url)
            }
        } else if let hackerNewsURL {
            ShareLink(item: hackerNewsURL)
        }
    }
}
