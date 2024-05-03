//
//  FirebaseItemDTO.swift
//  Hax
//
//  Created by Luis Fariña on 11/5/24.
//

/// [Source](https://github.com/HackerNews/API?tab=readme-ov-file#items)
struct FirebaseItemDTO: Decodable {

    // MARK: Properties

    let by: String?
    let dead: Bool?
    let deleted: Bool?
    let descendants: Int?
    let id: Int
    let kids: [Int]?
    let parent: Int?
    let parts: [Int]?
    let poll: Int?
    let score: Int?
    let text: String?
    let time: Int?
    let title: String?
    let type: String?
    let url: String?
}
