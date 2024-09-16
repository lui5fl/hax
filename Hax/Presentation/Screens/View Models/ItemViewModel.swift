//
//  ItemViewModel.swift
//  Hax
//
//  Created by Luis Fariña on 18/5/22.
//

import SwiftUI

@MainActor
protocol ItemViewModelProtocol: ObservableObject {

    // MARK: Properties

    /// Whether the view model is fetching items.
    var isLoading: Bool { get }

    /// The error to display in the view.
    var error: Error? { get set }

    /// The item whose information and comments are to be displayed on the view.
    var item: Item { get }

    /// The item corresponding to a Hacker News link in a comment.
    var secondaryItem: Item? { get set }

    /// The array of comments to display in the list.
    var comments: [Comment] { get }

    /// The URL to navigate to.
    var url: IdentifiableURL? { get set }

    /// The user whose information is to be displayed.
    var user: IdentifiableString? { get set }

    /// The identifier of the comment to be highlighted.
    var highlightedCommentId: Int? { get }

    /// The title for the view.
    var title: String { get }

    // MARK: Methods

    /// Called when the view appears.
    func onViewAppear() async

    /// Called when a user is tapped.
    func onUserTap(item: Item)

    /// Called when a comment is tapped.
    func onCommentTap(comment: Comment)

    /// Called when a link in a comment is tapped.
    func onCommentLinkTap(url: URL) -> OpenURLAction.Result

    /// Called when the user requests a refresh.
    func onRefreshRequest() async
}

class ItemViewModel: ItemViewModelProtocol {

    // MARK: Properties

    @Published var isLoading = true
    @Published var error: Error?
    @Published var item: Item
    @Published var secondaryItem: Item?
    @Published var comments: [Comment] = []
    @Published var url: IdentifiableURL?
    @Published var user: IdentifiableString?
    @Published private(set) var highlightedCommentId: Int?

    var title: String {
        guard let descendants = item.descendants else {
            return ""
        }

        return String(localized: "\(descendants) comments")
    }

    /// The service to use for fetching Hacker News data.
    private let hackerNewsService: HackerNewsServiceProtocol

    /// The service to use to search for regular expressions.
    private let regexService: RegexServiceProtocol

    /// Whether the item should be updated when the view appears.
    private let shouldFetchItem: Bool

    /// The original item, which is used to fetch the latest information instead of the main item
    /// if the latter has been modified to highlight a comment.
    private let originalItem: Item

    /// Whether the view has already appeared once.
    private var viewHasAppearedOnce = false

    /// The array of comments that have been fetched for now.
    private var allComments: [Comment] = []

    // MARK: Initialization

    init(
        item: Item,
        hackerNewsService: HackerNewsServiceProtocol = HackerNewsService.shared,
        regexService: RegexServiceProtocol = RegexService(),
        shouldFetchItem: Bool = true
    ) {
        self.item = item
        self.hackerNewsService = hackerNewsService
        self.regexService = regexService
        self.shouldFetchItem = shouldFetchItem
        originalItem = item
    }

    // MARK: Methods

    func onViewAppear() async {
        guard !viewHasAppearedOnce else {
            return
        }

        viewHasAppearedOnce = true
        await fetchItem()
    }

    func onUserTap(item: Item) {
        user = item.author.map(IdentifiableString.init)
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

    func onCommentLinkTap(url: URL) -> OpenURLAction.Result {
        if let itemID = regexService.itemID(url: url) {
            secondaryItem = Item(id: itemID)
            return .handled
        } else if let userID = regexService.userID(url: url) {
            user = IdentifiableString(userID)
            return .handled
        } else if url.scheme?.hasPrefix("http") == true {
            self.url = IdentifiableURL(url)
            return .handled
        } else {
            return .systemAction
        }
    }

    func onRefreshRequest() async {
        await fetchItem(isRefresh: true)
    }
}

// MARK: - Private extension

private extension ItemViewModel {

    // MARK: Methods

    /// Fetches the item.
    func fetchItem(isRefresh: Bool = false) async {
        do {
            let item: Item
            let comments: [Comment]
            let shouldFetchItem = shouldFetchItem || isRefresh

            if shouldFetchItem {
                item = try await hackerNewsService.item(
                    id: originalItem.id,
                    shouldFetchComments: true
                )
            } else {
                item = self.item
            }

            if shouldFetchItem,
               let storyId = item.storyId,
               storyId != item.id {
                self.item = try await hackerNewsService.item(
                    id: storyId,
                    shouldFetchComments: false
                )
                let comment = Comment(item: item)
                comments = [comment] + item.comments.map { comment in
                    Comment(
                        item: comment.item,
                        depth: comment.depth + 1
                    )
                }
                highlightedCommentId = comment.id
            } else {
                self.item = item
                comments = item.comments
            }

            self.comments = comments
            allComments = comments
        } catch {
            self.error = error
        }

        isLoading = false
    }
}
