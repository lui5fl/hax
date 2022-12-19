//
//  BundleMock.swift
//  HaxTests
//
//  Created by Luis Fariña on 21/12/22.
//

import Foundation

final class BundleMock: Bundle {

    // MARK: Properties

    var infoDictionaryStub: [String: Any]?
    private(set) var objectCallCount = 0

    // MARK: Methods

    override func object(forInfoDictionaryKey key: String) -> Any? {
        objectCallCount += 1

        return infoDictionaryStub?[key]
    }
}
