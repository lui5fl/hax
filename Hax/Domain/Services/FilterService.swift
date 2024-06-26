//
//  FilterService.swift
//  Hax
//
//  Created by Luis Fariña on 13/4/24.
//

import SwiftData

protocol FilterServiceProtocol {

    // MARK: Methods

    func filtered(items: [Item]) -> [Item]
}

struct FilterService: FilterServiceProtocol {

    // MARK: Properties

    private let modelContext: ModelContext

    // MARK: Initialization

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: Methods

    func filtered(items: [Item]) -> [Item] {
        let keywordFilters = fetch() as [KeywordFilter]
        let userFilters = fetch() as [UserFilter]

        return items.filter { item in
            !item.deleted &&
            !item.dead &&
            noFilteredKeywordIsPresent(
                item: item,
                keywordFilters: keywordFilters
            ) &&
            userIsNotFiltered(
                item: item,
                userFilters: userFilters
            )
        }
    }
}

// MARK: - Private extension

private extension FilterService {

    // MARK: Methods

    func noFilteredKeywordIsPresent(
        item: Item,
        keywordFilters: [KeywordFilter]
    ) -> Bool {
        keywordFilters.allSatisfy { keywordFilter in
            [
                item.body,
                item.url?.absoluteString,
                item.title
            ]
                .allSatisfy { string in
                    guard let string else {
                        return true
                    }

                    return !string.localizedLowercase.contains(word: keywordFilter.keyword)
                }
        }
    }

    func userIsNotFiltered(
        item: Item,
        userFilters: [UserFilter]
    ) -> Bool {
        guard let author = item.author else {
            return true
        }

        return !userFilters.contains { userFilter in
            userFilter.user == author
        }
    }

    func fetch<T: PersistentModel>() -> [T] {
        (try? modelContext.fetch(FetchDescriptor<T>())) ?? []
    }
}
