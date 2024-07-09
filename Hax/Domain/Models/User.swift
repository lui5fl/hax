//
//  User.swift
//  Hax
//
//  Created by Luis Fariña on 31/5/24.
//

import Foundation

struct User {

    // MARK: Properties

    let id: String
    let creationDate: Date
    let karma: Int
    let description: String?
    let url: URL?

    // MARK: Initialization

    init(
        id: String,
        creationDate: Date,
        karma: Int,
        description: String? = nil
    ) {
        self.id = id
        self.creationDate = creationDate
        self.karma = karma
        self.description = description?.htmlToMarkdown()

        url = URL(
            string: "https://\(Constant.hackerNewsUserURLString)\(id)"
        )
    }

    init(firebaseUserDTO: FirebaseUserDTO) {
        self.init(
            id: firebaseUserDTO.id,
            creationDate: Date(
                timeIntervalSince1970: TimeInterval(
                    firebaseUserDTO.created
                )
            ),
            karma: firebaseUserDTO.karma,
            description: firebaseUserDTO.about
        )
    }
}
