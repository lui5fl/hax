//
//  MenuViewModel.swift
//  Hax
//
//  Created by Luis Fariña on 26/5/22.
//

import Foundation

@MainActor
protocol MenuViewModelProtocol: ObservableObject {

    // MARK: Properties

    /// The array of feeds to display in the list.
    var feeds: [Feed] { get }

    /// The error to display in the view.
    var error: Error? { get set }

    /// Whether the "Open Hacker News Link" alert is presented.
    var openHackerNewsLinkAlertIsPresented: Bool { get set }

    /// The text in the text field of the "Open Hacker News Link" alert.
    var openHackerNewsLinkAlertText: String { get set }

    /// The item corresponding to the specified Hacker News link, if the latter is valid.
    func itemForHackerNewsLink() -> Item?
}

final class MenuViewModel: MenuViewModelProtocol {

    // MARK: Properties

    let feeds = Feed.allCases
    @Published var error: Error?
    @Published var openHackerNewsLinkAlertIsPresented = false
    @Published var openHackerNewsLinkAlertText = ""

    /// The service to use to search for regular expressions.
    private let regexService: RegexServiceProtocol

    // MARK: Initialization

    init(regexService: RegexServiceProtocol = RegexService()) {
        self.regexService = regexService
    }

    // MARK: Methods

    func itemForHackerNewsLink() -> Item? {
        defer {
            openHackerNewsLinkAlertText = ""
        }

        guard
            let url = URL(string: openHackerNewsLinkAlertText),
            let itemID = regexService.itemID(url: url)
        else {
            error = MenuViewModelError.invalidHackerNewsLink
            return nil
        }

        return Item(id: itemID)
    }
}

private enum MenuViewModelError: LocalizedError {

    // MARK: Cases

    case invalidHackerNewsLink

    // MARK: Properties

    var errorDescription: String? {
        let errorDescription: String
        switch self {
        case .invalidHackerNewsLink:
            errorDescription = "Invalid Hacker News Link"
        }

        return errorDescription
    }

    var recoverySuggestion: String? {
        let recoverySuggestion: String?
        switch self {
        case .invalidHackerNewsLink:
            recoverySuggestion = """
            The link should be similar to the following one:

            \(Constant.hackerNewsItemURLString)1
            """
        }

        return recoverySuggestion
    }
}
