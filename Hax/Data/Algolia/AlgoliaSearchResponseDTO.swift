//
//  AlgoliaSearchResponseDTO.swift
//  Hax
//
//  Created by Luis Fariña on 28/8/24.
//

/// [Source](https://hn.algolia.com/api)
struct AlgoliaSearchResponseDTO: Decodable {

    // MARK: Properties

    let hits: [AlgoliaSearchResultDTO]
}
