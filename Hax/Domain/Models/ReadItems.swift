//
//  ReadItems.swift
//  Hax
//
//  Created by Luis Fariña on 22/2/25.
//

import Foundation

@MainActor
@Observable
final class ReadItems {

    // MARK: Properties

    static let shared = ReadItems()
    private let userDefaults: UserDefaults
    private let limit: Int
    private let key = UserDefaults.Key.readItems
    private var itemIdentifiers: [Int]
    private var itemIdentifierSet: Set<Int> = []

    // MARK: Initialization

    init(userDefaults: UserDefaults = .standard, limit: Int = 100) {
        self.userDefaults = userDefaults
        self.limit = limit
        itemIdentifiers = userDefaults
            .array(forKey: key) as? [Int] ?? []
        itemIdentifierSet = Set(itemIdentifiers)
    }

    // MARK: Methods

    func add(_ itemIdentifier: Int) {
        if contains(itemIdentifier),
           let index = itemIdentifiers.firstIndex(of: itemIdentifier) {
            itemIdentifiers.remove(at: index)
            itemIdentifiers.append(itemIdentifier)
        } else {
            itemIdentifiers.append(itemIdentifier)

            if itemIdentifiers.count > limit {
                itemIdentifiers = itemIdentifiers.suffix(limit)
            }

            itemIdentifierSet.insert(itemIdentifier)
        }

        userDefaults.set(itemIdentifiers, forKey: key)
    }

    func contains(_ itemIdentifier: Int) -> Bool {
        itemIdentifierSet.contains(itemIdentifier)
    }
}
