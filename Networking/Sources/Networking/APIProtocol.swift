//
//  APIProtocol.swift
//
//
//  Created by Luis Fariña on 10/5/24.
//

public protocol APIProtocol {

    // MARK: Types

    associatedtype Endpoint: EndpointProtocol

    // MARK: Properties

    /// The scheme subcomponent of the API's base URL.
    ///
    /// Example: `https`
    var scheme: String { get }

    /// The host subcomponent of the API's base URL.
    ///
    /// Example: `api.example.com`
    var host: String { get }
}
