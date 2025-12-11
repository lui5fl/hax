//
//  UserDefaultsExtension.swift
//  Hax
//
//  Created by Luis Fariña on 26/5/22.
//

import Foundation

extension UserDefaults {

    enum Key {
        static let defaultFeed = "defaultFeed"
        static let discussionAtAGlanceIsEnabled = "discussionAtAGlanceIsEnabled"
        static let numberOfLaunches = "numberOfLaunches"
        static let readItems = "readItems"
        static let reviewHasBeenRequested = "reviewHasBeenRequested"
        static let url = "url"
    }
}
