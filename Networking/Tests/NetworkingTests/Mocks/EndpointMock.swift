//
//  EndpointMock.swift
//
//
//  Created by Luis Fariña on 17/5/24.
//

import Foundation
import Networking

final class EndpointMock: EndpointProtocol {

    // MARK: Properties

    let path: String
    let queryItems: [URLQueryItem]?

    // MARK: Initialization

    init(path: String, queryItems: [URLQueryItem]? = nil) {
        self.path = path
        self.queryItems = queryItems
    }
}
