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
    private(set) var itemIDCallCount = 0

    // MARK: Methods

    func itemID(url: URL) -> Int? {
        itemIDCallCount += 1

        return itemIDStub
    }
}
