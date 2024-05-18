//
//  AlgoliaAPI.swift
//  Hax
//
//  Created by Luis Fariña on 10/5/24.
//

import Networking

struct AlgoliaAPI: APIProtocol {

    // MARK: Types

    enum Endpoint: EndpointProtocol {

        // MARK: Cases

        case item(id: Int)

        // MARK: Properties

        var path: String {
            var path = "/api/v1/"

            switch self {
            case .item(let id):
                path += "items/\(id)"
            }

            return path
        }
    }

    // MARK: Properties

    let scheme = "https"
    let host = "hn.algolia.com"
}
