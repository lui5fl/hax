//
//  ItemViewModel.swift
//  Hax
//
//  Created by Luis Fariña on 18/5/22.
//

import Combine
import UIKit

@MainActor class ItemViewModel: ObservableObject {

    // MARK: Properties

    /// Whether the view model is fetching items or not.
    @Published var isLoading = true

    /// The error to display in the view.
    @Published var error: Error?

    /// The item whose information and comments are to be displayed on the view.
    @Published var item: Item

    /// The array of comments to display in the list.
    @Published var comments: [Comment] = []

    /// The URL to navigate to.
    @Published var url: IdentifiableURL?

    /// The title for the view.
    var title: String {
        guard let descendants = item.descendants else {
            return ""
        }

        return "\(descendants) comment\(descendants != 1 ? "s" : "")"
    }

    /// The page of comments to be fetched.
    private var page = 1

    /// The array of comments that have been fetched for now.
    private var allComments: [Comment] = []

    /// The set of subscribers to the requests of the item and its comments.
    private var cancellables: Set<AnyCancellable> = []

    // MARK: Initialization

    init(item: Item) {
        self.item = item
    }

    // MARK: Methods

    /// Fetches the item and then fetches its comments.
    func fetchItem() {
        HackerNewsService.shared.item(id: item.id)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        self?.fetchComments()
                    case .failure(let error):
                        self?.error = error
                    }
                },
                receiveValue: { [weak self] value in
                    self?.item = value
                }
            )
            .store(in: &cancellables)
    }

    /// Fetches the next page of comments in the item.
    func fetchMoreComments() {
        page += 1
        fetchComments()
    }

    /// Either collapses or expands the selected comment depending on its current state.
    func toggle(comment: Comment) {
        guard let index = allComments.firstIndex(of: comment) else {
            return
        }

        allComments[index].isCollapsed.toggle()

        let nextIndex = index + 1
        for otherIndex in nextIndex..<allComments.count {
            let otherComment = allComments[otherIndex]
            guard otherComment.depth > comment.depth else {
                break
            }

            let commentIsCollapsed = allComments[index].isCollapsed
            allComments[otherIndex].isCollapsed = commentIsCollapsed
            allComments[otherIndex].isHidden = commentIsCollapsed
        }

        comments = allComments.filter {
            !$0.isHidden
        }
    }
}

// MARK: - Private extension

private extension ItemViewModel {

    /// Fetches the current page of comments in the item.
    func fetchComments() {
        HackerNewsService.shared.comments(
            in: item,
            page: page
        )
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.error = error
                    }
                },
                receiveValue: { [weak self] value in
                    self?.comments += value
                    self?.allComments += value
                }
            )
            .store(in: &cancellables)
    }
}
