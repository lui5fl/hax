//
//  UserDefaultsMock.swift
//  HaxTests
//
//  Created by Luis Fariña on 20/12/22.
//

import Foundation

final class UserDefaultsMock: UserDefaults {

    // MARK: Properties

    private(set) var setCallCount = Int.zero
    private(set) var stringCallCount = Int.zero
    private var dictionary: [String: Any] = [:]

    // MARK: Methods

    override func set(_ value: Any?, forKey defaultName: String) {
        setCallCount += 1
        dictionary[defaultName] = value
    }

    override func string(forKey defaultName: String) -> String? {
        stringCallCount += 1

        return dictionary[defaultName] as? String
    }

    override func array(forKey defaultName: String) -> [Any]? {
        dictionary[defaultName] as? [Any]
    }
}
