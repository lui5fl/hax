//
//  FilterServiceMock.swift
//  HaxTests
//
//  Created by Luis Fariña on 17/5/24.
//

@testable import Hax

actor FilterServiceMock: FilterServiceProtocol {

    // MARK: Properties

    private(set) var filteredItemsCallCount = Int.zero

    // MARK: Methods

    func filtered(items: [Item]) -> [Item] {
        filteredItemsCallCount += 1

        return items
    }
}
