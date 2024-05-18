//
//  UserFilter.swift
//  Hax
//
//  Created by Luis Fariña on 13/4/24.
//

import SwiftData

@Model
final class UserFilter {

    // MARK: Properties

    @Attribute(.unique)
    let user: String

    // MARK: Initialization

    init(user: String) {
        self.user = user
    }
}
