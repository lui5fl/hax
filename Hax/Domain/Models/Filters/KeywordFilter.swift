//
//  KeywordFilter.swift
//  Hax
//
//  Created by Luis Fariña on 13/4/24.
//

import SwiftData

@Model
final class KeywordFilter {

    // MARK: Properties

    @Attribute(.unique)
    let keyword: String

    // MARK: Initialization

    init(keyword: String) {
        self.keyword = keyword
    }
}
