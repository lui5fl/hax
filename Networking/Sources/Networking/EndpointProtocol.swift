//
//  EndpointProtocol.swift
//
//
//  Created by Luis Fariña on 10/5/24.
//

public protocol EndpointProtocol {

    // MARK: Properties

    /// The path subcomponent of the endpoint's URL.
    ///
    /// Example: `/example`
    var path: String { get }
}
