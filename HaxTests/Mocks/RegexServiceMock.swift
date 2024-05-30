//
//  RegexServiceMock.swift
//  HaxTests
//
//  Created by Luis Fariña on 26/3/24.
//

import Foundation
@testable import Hax

final class RegexServiceMock: RegexServiceProtocol {

    // MARK: Properties

    var itemIDStub: Int?
    var userIDStub: String?

    private(set) var itemIDCallCount = Int.zero
    private(set) var userIDCallCount = Int.zero

    // MARK: Methods

    func itemID(url: URL) -> Int? {
        itemIDCallCount += 1

        return itemIDStub
    }

    func userID(url: URL) -> String? {
        userIDCallCount += 1

        return userIDStub
    }
}
