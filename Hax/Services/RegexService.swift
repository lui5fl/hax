//
//  RegexService.swift
//  Hax
//
//  Created by Luis Fariña on 20/3/24.
//

import Foundation
import RegexBuilder

protocol RegexServiceProtocol {

    // MARK: Methods

    /// Looks for a Hacker News item identifier in the specified URL.
    ///
    /// - Parameters:
    ///   - url: The URL in which to look for a Hacker News item identifier
    func itemID(url: URL) -> Int?
}

final class RegexService: RegexServiceProtocol {

    // MARK: Properties

    private lazy var itemIDPattern = {
        Regex {
            ChoiceOf {
                "hax://item/"
                "news.ycombinator.com/item?id="
            }
            Capture {
                OneOrMore(.digit)
            }
        }
    }()

    // MARK: Methods

    func itemID(url: URL) -> Int? {
        guard let match = url.absoluteString.firstMatch(of: itemIDPattern) else {
            return nil
        }

        let (_, id) = match.output

        return Int(id)
    }
}
