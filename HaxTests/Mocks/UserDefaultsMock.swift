//
//  UserDefaultsMock.swift
//  HaxTests
//
//  Created by Luis Fariña on 20/12/22.
//

import Foundation

final class UserDefaultsMock: UserDefaults {

    // MARK: Properties

    private var dictionary: [String: Any] = [:]
    private(set) var stringCallCount = Int.zero

    // MARK: Methods

    override func set(_ value: Any?, forKey defaultName: String) {
        dictionary[defaultName] = value
    }

    override func string(forKey defaultName: String) -> String? {
        stringCallCount += 1

        return dictionary[defaultName] as? String
    }
}
