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

    /// Whether the settings view is presented.
    var settingsViewIsPresented: Bool { get set }
}

final class MenuViewModel: MenuViewModelProtocol {

    // MARK: Properties

    let feeds = Feed.allCases
    @Published var settingsViewIsPresented = false
}
