//
//  EndpointProtocol.swift
//
//
//  Created by Luis Fariña on 10/5/24.
//

import Foundation

public protocol EndpointProtocol: Sendable {

    // MARK: Properties

    /// The path subcomponent of the endpoint's URL.
    ///
    /// Example: `/example`
    var path: String { get }

    /// The parameters of the URL.
    var queryItems: [URLQueryItem]? { get }
}
