//
//  ItemViewModel.swift
//  Hax
//
//  Created by Luis Fariña on 18/5/22.
//

import Combine
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

    /// The title for the view.
    var title: String { get }

    // MARK: Methods

    /// Called when the view appears.
    func onViewAppear()

    /// Called when a comment appears.
    func onCommentAppear(comment: Comment)

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

    var title: String {
        guard let descendants = item.descendants else {
            return ""
        }

        return "\(descendants) comment\(descendants != 1 ? "s" : "")"
    }

    /// The service to use for fetching Hacker News data.
    private let hackerNewsService: HackerNewsServiceProtocol

    /// The service to use to search for regular expressions.
    private let regexService: RegexServiceProtocol

    /// Whether the view has already appeared once.
    private var viewHasAppearedOnce = false

    /// The page of comments to be fetched.
    private var page = Constant.initialPage

    /// The array of comments that have been fetched for now.
    private var allComments: [Comment] = []

    // MARK: Initialization

    init(
        item: Item,
        hackerNewsService: HackerNewsServiceProtocol = HackerNewsService.shared,
        regexService: RegexServiceProtocol = RegexService()
    ) {
        self.item = item
        self.hackerNewsService = hackerNewsService
        self.regexService = regexService
    }

    // MARK: Methods

    func onViewAppear() {
        guard !viewHasAppearedOnce else {
            return
        }

        viewHasAppearedOnce = true

        Task {
            await fetchItem()
        }
    }

    func onCommentAppear(comment: Comment) {
        guard comment == comments.last else {
            return
        }

        page += 1

        Task {
            await fetchComments()
        }
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
        } else if url.scheme?.hasPrefix("http") == true {
            self.url = IdentifiableURL(url)
            return .handled
        } else {
            return .systemAction
        }
    }

    func onRefreshRequest() async {
        await fetchItem()
    }
}

// MARK: - Private extension

private extension ItemViewModel {

    // MARK: Types

    enum Constant {
        static let initialPage = 1
    }

    // MARK: Methods

    /// Fetches the item.
    func fetchItem() async {
        do {
            item = try await hackerNewsService.item(id: item.id)
            await fetchComments(resetCache: true)
        } catch {
            isLoading = false
            self.error = error
        }
    }

    /// Fetches the current page of comments in the item.
    ///
    /// - Parameters:
    ///   - resetCache: Whether the cached items should be cleared
    func fetchComments(resetCache: Bool = false) async {
        do {
            if resetCache {
                page = Constant.initialPage
            }
            let comments = try await hackerNewsService.comments(
                in: item,
                page: page,
                pageSize: 5
            )
            if resetCache {
                self.comments = comments
                allComments = comments
            } else {
                self.comments += comments
                allComments += comments
            }
        } catch {
            self.error = error
        }

        isLoading = false
    }
}
