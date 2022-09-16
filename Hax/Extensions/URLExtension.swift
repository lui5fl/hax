//
//  URLExtension.swift
//  Hax
//
//  Created by Luis Fariña on 18/5/22.
//

import Foundation

extension URL {

    /// Returns the URL in a simplified form as a string.
    func simpleString() -> String {
        let components = absoluteString.components(separatedBy: "://")

        guard
            let stringAfterScheme = components[safe: 1] ?? components.first,
            let stringBeforeFirstSlash = stringAfterScheme
                .split(separator: "/")
                .first
        else {
            return absoluteString
        }

        let domainNameAndTLD = stringBeforeFirstSlash
            .split(separator: ".")
            .suffix(2)
            .joined(separator: ".")

        return domainNameAndTLD
    }
}
