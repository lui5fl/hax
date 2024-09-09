//
//  FirebaseAPI.swift
//  Hax
//
//  Created by Luis Fariña on 10/5/24.
//

import Foundation
import Networking

struct FirebaseAPI: APIProtocol {

    // MARK: Types

    enum Endpoint: EndpointProtocol {

        // MARK: Cases

        case feed(resource: String)
        case item(id: Int)
        case user(id: String)

        // MARK: Properties

        var path: String {
            var path = "/v0/"

            switch self {
            case .feed(let resource):
                path += "\(resource).json"
            case .item(let id):
                path += "item/\(id).json"
            case .user(let id):
                path += "user/\(id).json"
            }

            return path
        }

        var queryItems: [URLQueryItem]? {
            nil
        }
    }

    // MARK: Properties

    let scheme = "https"
    let host = "hacker-news.firebaseio.com"
}
