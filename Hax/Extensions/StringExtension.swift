//
//  StringExtension.swift
//  Hax
//
//  Created by Luis Fariña on 29/5/22.
//

import Foundation
import RegexBuilder

extension String {

    // MARK: Methods

    func contains(word: String) -> Bool {
        contains(
            Regex {
                Anchor.wordBoundary
                word
                Anchor.wordBoundary
            }
        )
    }

    // swiftlint:disable function_body_length
    /// Returns the result of converting any HTML content in the string into Markdown.
    func htmlToMarkdown() -> String {
        var string = self

        [
            // swiftlint:disable colon
            "&#x27;"    : "'",
            "&#x2F;"    : "/",
            "&amp;"     : "&",
            "&gt;"      : ">",
            "&lt;"      : "<",
            "&quot;"    : "\"",
            "</code>"   : "`",
            "</i>"      : "*",
            "</pre>"    : "",
            "<code>"    : "`",
            "<i>"       : "*",
            "<p>"       : "\n\n",
            "<pre>"     : ""
            // swiftlint:enable colon
        ]
            .forEach {
                string = string.replacingOccurrences(
                    of: $0.key,
                    with: $0.value
                )
            }

        guard
            let regex = try? NSRegularExpression(
                pattern: "<a.*?href=\"([^\"]+)\".*?>[^<]+</a>"
            )
        else {
            return string
        }

        let matches = regex.matches(
            in: string,
            range: NSRange(
                string.startIndex..<string.endIndex,
                in: string
            )
        )

        var linksToBeReplaced: [String: String] = [:]
        for match in matches {
            guard
                let linkTagRange = Range(
                    match.range(at: .zero),
                    in: string
                )
            else {
                continue
            }

            let linkTag = String(string[linkTagRange])

            guard
                let linkRange = Range(
                    match.range(at: 1),
                    in: string
                )
            else {
                continue
            }

            let link = String(string[linkRange])

            linksToBeReplaced[linkTag] = link
        }

        for link in linksToBeReplaced {
            string = string.replacingOccurrences(
                of: link.key,
                with: link.value
            )
        }

        return string
    }
    // swiftlint:enable function_body_length
}
