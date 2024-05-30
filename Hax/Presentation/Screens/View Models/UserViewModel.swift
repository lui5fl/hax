//
//  UserViewModel.swift
//  Hax
//
//  Created by Luis Fariña on 31/5/24.
//

import Foundation

@MainActor
protocol UserViewModelProtocol {

    // MARK: Properties

    /// The error to display in the view.
    var error: Error? { get set }

    /// The user whose information is to be displayed on the view.
    var user: User? { get }

    /// The URL to navigate to.
    var url: IdentifiableURL? { get set }

    // MARK: Methods

    /// Called when the view appears.
    func onViewAppear() async

    var id: String { get }
}

@Observable
final class UserViewModel: UserViewModelProtocol {

    // MARK: Properties

    var error: Error?
    var user: User?
    var url: IdentifiableURL?

    /// The identifier of the user.
    let id: String

    /// The service to use for fetching Hacker News data.
    private let hackerNewsService: HackerNewsServiceProtocol

    // MARK: Initialization

    init(
        id: String,
        hackerNewsService: HackerNewsServiceProtocol = HackerNewsService.shared
    ) {
        self.id = id
        self.hackerNewsService = hackerNewsService
    }

    // MARK: Methods

    func onViewAppear() async {
        do {
            user = try await hackerNewsService.user(id: id)
        } catch {
            self.error = error
        }
    }
}
