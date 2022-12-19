//
//  ItemViewModel.swift
//  Hax
//
//  Created by Luis Fariña on 18/5/22.
//

import Combine
import UIKit

@MainActor
protocol ItemViewModelProtocol: ObservableObject {

    // MARK: Properties

    /// Whether the view model is fetching items.
    var isLoading: Bool { get }

    /// The error to display in the view.
    var error: Error? { get set }

    /// The item whose information and comments are to be displayed on the view.
    var item: Item { get }

    /// The array of comments to display in the list.
    var comments: [Comment] { get }

    /// The URL to navigate to.
    var url: IdentifiableURL? { get set }

    /// The title for the view.
    var title: String { get }

    // MARK: Methods

    /// Called when the view appears.
    func onViewAppear()

    /// Called when a comment appears.
    func onCommentAppear(comment: Comment)

    /// Called when a comment is tapped.
    func onCommentTap(comment: Comment)
}

class ItemViewModel: ItemViewModelProtocol {

    // MARK: Properties

    @Published var isLoading = true
    @Published var error: Error?
    @Published var item: Item
    @Published var comments: [Comment] = []
    @Published var url: IdentifiableURL?

    var title: String {
        guard let descendants = item.descendants else {
            return ""
        }

        return "\(descendants) comment\(descendants != 1 ? "s" : "")"
    }

    /// The service to use for fetching Hacker News data.
    private let hackerNewsService: HackerNewsServiceProtocol

    /// The page of comments to be fetched.
    private var page = 1

    /// The array of comments that have been fetched for now.
    private var allComments: [Comment] = []

    /// The set of subscribers to the requests of the item and its comments.
    private var cancellables: Set<AnyCancellable> = []

    // MARK: Initialization

    init(
        item: Item,
        hackerNewsService: HackerNewsServiceProtocol = HackerNewsService.shared
    ) {
        self.item = item
        self.hackerNewsService = hackerNewsService
    }

    // MARK: Methods

    func onViewAppear() {
        hackerNewsService.item(id: item.id)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        self?.fetchComments()
                    case .failure(let error):
                        self?.isLoading = false
                        self?.error = error
                    }
                },
                receiveValue: { [weak self] value in
                    self?.item = value
                }
            )
            .store(in: &cancellables)
    }

    func onCommentAppear(comment: Comment) {
        guard comment == comments.last else {
            return
        }

        page += 1
        fetchComments()
    }

    func onCommentTap(comment: Comment) {
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
        hackerNewsService.comments(
            in: item,
            page: page,
            pageSize: 5
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
