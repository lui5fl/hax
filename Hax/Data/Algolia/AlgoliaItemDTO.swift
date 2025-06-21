//
//  AlgoliaItemDTO.swift
//  Hax
//
//  Created by Luis Fariña on 11/5/24.
//

/// [Source](https://hn.algolia.com/api)
struct AlgoliaItemDTO: Decodable, Sendable {

    // MARK: Properties

    let author: String?
    let children: [Self]
    let createdAt: String
    let createdAtI: Int
    let id: Int
    let options: [Int]
    let parentId: Int?
    let points: Int?
    let storyId: Int?
    let text: String?
    let title: String?
    let type: String
    let url: String?
}
