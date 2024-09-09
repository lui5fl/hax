//
//  SearchViewModel.swift
//  Hax
//
//  Created by Luis Fariña on 8/9/24.
//

import Foundation

@MainActor
@Observable
final class SearchViewModel {

    // MARK: Properties

    private(set) var isLoading = false
    var error: Error?
    private(set) var items: [Item] = []
    var text = ""
    private let hackerNewsService: HackerNewsServiceProtocol

    // MARK: Initialization

    init(
        hackerNewsService: HackerNewsServiceProtocol = HackerNewsService.shared
    ) {
        self.hackerNewsService = hackerNewsService
    }

    // MARK: Methods

    func onSubmit() async {
        items = []
        isLoading = true

        do {
            items = try await hackerNewsService.search(query: text)
        } catch {
            self.error = error
        }

        isLoading = false
    }
}
