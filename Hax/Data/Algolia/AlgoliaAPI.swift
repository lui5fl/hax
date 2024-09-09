//
//  AlgoliaAPI.swift
//  Hax
//
//  Created by Luis Fariña on 10/5/24.
//

import Foundation
import Networking

struct AlgoliaAPI: APIProtocol {

    // MARK: Types

    enum Endpoint: EndpointProtocol {

        // MARK: Cases

        case item(id: Int)
        case search(query: String)

        // MARK: Properties

        var path: String {
            var path = "/api/v1/"

            switch self {
            case .item(let id):
                path += "items/\(id)"
            case .search:
                path += "search"
            }

            return path
        }

        var queryItems: [URLQueryItem]? {
            switch self {
            case .item:
                nil
            case .search(let query):
                [
                    URLQueryItem(name: "query", value: query),
                    URLQueryItem(name: "tags", value: "story")
                ]
            }
        }
    }

    // MARK: Properties

    let scheme = "https"
    let host = "hn.algolia.com"
}
