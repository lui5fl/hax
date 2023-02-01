//
//  XCTestCaseExtension.swift
//  HaxTests
//
//  Created by Luis Fariña on 22/12/22.
//

import Combine
import XCTest

extension XCTestCase {

    // MARK: Methods

    /// Creates an expectation which is fulfilled once the specified `Published` property
    /// emits a value other than its initial one.
    ///
    /// - Parameters:
    ///   - publishedProperty: The `Published` property to be subscribed to
    ///   - description: The description of the expectation
    func expectation<T>(
        publishedProperty: Published<T>.Publisher,
        description: String
    ) -> AnyCancellable {
        let expectation = expectation(description: description)

        return publishedProperty
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
    }
}
