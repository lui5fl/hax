//
//  IdentifiableURL.swift
//  Hax
//
//  Created by Luis Fariña on 26/5/22.
//

import Foundation

struct IdentifiableURL: Identifiable {

    // MARK: Properties

    let id = UUID()
    let url: URL

    // MARK: Initialization

    init?(_ url: URL?) {
        guard let url = url else {
            return nil
        }

        self.url = url
    }
}
