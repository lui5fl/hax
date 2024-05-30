//
//  FirebaseUserDTO.swift
//  Hax
//
//  Created by Luis Fariña on 30/5/24.
//

/// [Source](https://github.com/HackerNews/API?tab=readme-ov-file#users)
struct FirebaseUserDTO: Decodable {

    // MARK: Properties

    let about: String?
    let created: Int
    let id: String
    let karma: Int
    let submitted: [Int]?
}
