//
//  DateExtension.swift
//  Hax
//
//  Created by Luis Fariña on 26/5/22.
//

import Foundation

extension Date {

    /// Returns the elapsed time between the date value and the current date as a formatted
    /// string.
    func elapsedTimeString() -> String {
        let currentTimeInterval = Self.now.timeIntervalSince1970
        let seconds = currentTimeInterval - timeIntervalSince1970

        if seconds < 60 {
            return String(localized: "\(Int(seconds))s")
        }

        let minutes = floor(seconds / 60)
        if minutes < 60 {
            return String(localized: "\(Int(minutes))m")
        }

        let hours = floor(minutes / 60)
        if hours < 24 {
            return String(localized: "\(Int(hours))h")
        }

        let days = floor(hours / 24)
        if days < 30 {
            return String(localized: "\(Int(days))d")
        }

        let months = floor(days / 30)
        if months < 12 {
            return String(localized: "\(Int(months))mo")
        }

        let years = floor(months / 12)

        return String(localized: "\(Int(years))y")
    }
}
