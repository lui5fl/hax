//
//  EndpointMock.swift
//
//
//  Created by Luis Fariña on 17/5/24.
//

import Networking

final class EndpointMock: EndpointProtocol {

    // MARK: Properties

    let path: String

    // MARK: Initialization

    init(path: String) {
        self.path = path
    }
}
