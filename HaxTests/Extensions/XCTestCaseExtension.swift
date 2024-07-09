//
//  XCTestCaseExtension.swift
//  HaxTests
//
//  Created by Luis Fariña on 22/12/22.
//

import Combine
import XCTest
@testable import Hax

extension XCTestCase {

    // MARK: Methods

    /// Decodes and returns an `AlgoliaItemDTO` instance from a JSON resource with
    /// the specified name located in the bundle of the current test target.
    ///
    /// - Parameters:
    ///   - jsonResourceName: The name of the JSON resource without the extension
    func algoliaItemDTO(
        jsonResourceName: String
    ) throws -> AlgoliaItemDTO {
        let data = try jsonData(resourceName: jsonResourceName)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return try decoder.decode(AlgoliaItemDTO.self, from: data)
    }

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

    /// Decodes and returns a `FirebaseItemDTO` instance from a JSON resource with
    /// the specified name located in the bundle of the current test target.
    ///
    /// - Parameters:
    ///   - jsonResourceName: The name of the JSON resource without the extension
    func firebaseItemDTO(
        jsonResourceName: String
    ) throws -> FirebaseItemDTO {
        try JSONDecoder().decode(
            FirebaseItemDTO.self,
            from: jsonData(resourceName: jsonResourceName)
        )
    }

    /// Decodes and returns a `FirebaseUserDTO` instance from a JSON resource with
    /// the specified name located in the bundle of the current test target.
    ///
    /// - Parameters:
    ///   - jsonResourceName: The name of the JSON resource without the extension
    func firebaseUserDTO(
        jsonResourceName: String
    ) throws -> FirebaseUserDTO {
        try JSONDecoder().decode(
            FirebaseUserDTO.self,
            from: jsonData(resourceName: jsonResourceName)
        )
    }
}

// MARK: - Private extension

private extension XCTestCase {

    // MARK: Methods

    /// Loads and returns the JSON data from a resource with the specified name located in
    /// the bundle of the current test target.
    ///
    /// - Parameters:
    ///   - resourceName: The name of the JSON resource without the extension
    func jsonData(resourceName: String) throws -> Data {
        let path = try XCTUnwrap(
            Bundle(for: Self.self)
                .path(
                    forResource: resourceName,
                    ofType: "json"
                )
        )
        let string = try String(contentsOfFile: path)

        return try XCTUnwrap(string.data(using: .utf8))
    }
}
