//
//  AlgoliaSearchResultDTO.swift
//  Hax
//
//  Created by Luis Fariña on 28/8/24.
//

/// [Source](https://hn.algolia.com/api)
struct AlgoliaSearchResultDTO: Decodable {

    // MARK: Properties

    let author: String?
    let children: [Int]?
    let createdAt: String
    let createdAtI: Int
    let numComments: Int?
    let objectID: String
    let points: Int?
    let storyId: Int?
    let title: String?
    let updatedAt: String
    let url: String?
}
