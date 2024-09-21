//
//  JSONHelper.swift
//  HaxTests
//
//  Created by Luis Fariña on 20/9/24.
//

import Foundation
import Testing
@testable import Hax

final class JSONHelper {

    // MARK: Initialization

    private init() {}

    // MARK: Methods

    /// Decodes and returns an `AlgoliaItemDTO` instance from a JSON resource with
    /// the specified name located in the bundle of the current test target.
    ///
    /// - Parameters:
    ///   - jsonResourceName: The name of the JSON resource without the extension
    static func algoliaItemDTO(
        jsonResourceName: String
    ) throws -> AlgoliaItemDTO {
        try snakeCaseJSONDecoder().decode(
            AlgoliaItemDTO.self,
            from: jsonData(resourceName: jsonResourceName)
        )
    }

    /// Decodes and returns an `AlgoliaSearchResponseDTO` instance from a JSON
    /// resource with the specified name located in the bundle of the current test target.
    ///
    /// - Parameters:
    ///   - jsonResourceName: The name of the JSON resource without the extension
    static func algoliaSearchResponseDTO(
        jsonResourceName: String
    ) throws -> AlgoliaSearchResponseDTO {
        try snakeCaseJSONDecoder().decode(
            AlgoliaSearchResponseDTO.self,
            from: jsonData(resourceName: jsonResourceName)
        )
    }

    /// Decodes and returns an `AlgoliaSearchResultDTO` instance from a JSON
    /// resource with the specified name located in the bundle of the current test target.
    ///
    /// - Parameters:
    ///   - jsonResourceName: The name of the JSON resource without the extension
    static func algoliaSearchResultDTO(
        jsonResourceName: String
    ) throws -> AlgoliaSearchResultDTO {
        try snakeCaseJSONDecoder().decode(
            AlgoliaSearchResultDTO.self,
            from: jsonData(resourceName: jsonResourceName)
        )
    }

    /// Decodes and returns a `FirebaseItemDTO` instance from a JSON resource with
    /// the specified name located in the bundle of the current test target.
    ///
    /// - Parameters:
    ///   - jsonResourceName: The name of the JSON resource without the extension
    static func firebaseItemDTO(
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
    static func firebaseUserDTO(
        jsonResourceName: String
    ) throws -> FirebaseUserDTO {
        try JSONDecoder().decode(
            FirebaseUserDTO.self,
            from: jsonData(resourceName: jsonResourceName)
        )
    }
}

// MARK: - Private extension

private extension JSONHelper {

    // MARK: Methods

    /// Loads and returns the JSON data from a resource with the specified name located in
    /// the bundle of the current test target.
    ///
    /// - Parameters:
    ///   - resourceName: The name of the JSON resource without the extension
    static func jsonData(resourceName: String) throws -> Data {
        let path = try #require(
            Bundle(for: Self.self)
                .path(
                    forResource: resourceName,
                    ofType: "json"
                )
        )
        let string = try String(contentsOfFile: path)

        return try #require(string.data(using: .utf8))
    }

    /// Creates and returns a `JSONDecoder` instance configured to convert snake case
    /// keys to camel case.
    static func snakeCaseJSONDecoder() -> JSONDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        return jsonDecoder
    }
}
