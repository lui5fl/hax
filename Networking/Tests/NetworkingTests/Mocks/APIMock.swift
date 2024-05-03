//
//  APIMock.swift
//
//
//  Created by Luis Fariña on 17/5/24.
//

import Networking

final class APIMock: APIProtocol {

    // MARK: Types

    typealias Endpoint = EndpointMock

    // MARK: Properties

    let scheme: String
    let host: String

    // MARK: Initialization

    init(scheme: String, host: String) {
        self.scheme = scheme
        self.host = host
    }
}
