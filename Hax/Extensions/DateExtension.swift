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
            return "\(Int(seconds))s"
        }

        let minutes = floor(seconds / 60)
        if minutes < 60 {
            return "\(Int(minutes))m"
        }

        let hours = floor(minutes / 60)
        if hours < 24 {
            return "\(Int(hours))h"
        }

        let days = floor(hours / 24)
        if days < 30 {
            return "\(Int(days))d"
        }

        let weeks = floor(days / 7)
        if weeks < 4 {
            return "\(Int(weeks))w"
        }

        let months = floor(days / 12)
        if months < 12 {
            return "\(Int(months))mo"
        }

        let years = floor(months / 12)

        return "\(Int(years))y"
    }
}
