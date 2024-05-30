//
//  IdentifiableString.swift
//  Hax
//
//  Created by Luis Fariña on 1/6/24.
//

struct IdentifiableString {

    // MARK: Properties

    let string: String

    // MARK: Initialization

    init(_ string: String) {
        self.string = string
    }
}

// MARK: - Identifiable

extension IdentifiableString: Identifiable {

    var id: String {
        string
    }
}
