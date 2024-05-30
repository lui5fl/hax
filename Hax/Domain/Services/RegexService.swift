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

    /// Looks for a Hacker News user identifier in the specified URL.
    ///
    /// - Parameters:
    ///   - url: The URL in which to look for a Hacker News user identifier
    func userID(url: URL) -> String?
}

final class RegexService: RegexServiceProtocol {

    // MARK: Properties

    private lazy var itemIDPattern = {
        Regex {
            ChoiceOf {
                "hax://item/"
                Constant.hackerNewsItemURLString
            }
            Capture {
                OneOrMore(.digit)
            }
        }
    }()

    private lazy var userIDPattern = {
        Regex {
            ChoiceOf {
                "hax://user/"
                Constant.hackerNewsUserURLString
            }
            Capture {
                OneOrMore(.word)
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

    func userID(url: URL) -> String? {
        guard let match = url.absoluteString.firstMatch(of: userIDPattern) else {
            return nil
        }

        let (_, id) = match.output

        return String(id)
    }
}
