//
//  DiscussionAtAGlanceViewModel.swift
//  Hax
//
//  Created by Luis Fariña on 9/12/25.
//

import Foundation
import FoundationModels

enum DiscussionAtAGlanceViewState: Equatable {

    // MARK: Cases

    case tapToGenerate
    case generating
    case generated(summary: String?)
}

@MainActor
protocol DiscussionAtAGlanceViewModelProtocol: Observable {

    // MARK: Properties

    var state: DiscussionAtAGlanceViewState { get }

    // MARK: Methods

    func onTap() async
}

@Observable
final class DiscussionAtAGlanceViewModel: DiscussionAtAGlanceViewModelProtocol {

    // MARK: Properties

    let id = UUID()
    private(set) var state: DiscussionAtAGlanceViewState = .tapToGenerate
    private let item: Item
    private let minimumNumberOfComments = 2

    // MARK: Initialization

    init?(item: Item) {
        guard
            #available(iOS 26.0, *),
            SystemLanguageModel.default.isAvailable,
            item
                .comments
                .lazy
                .filter(
                    {
                        $0.depth == .zero
                    }
                )
                .prefix(minimumNumberOfComments)
                .count == minimumNumberOfComments
        else {
            return nil
        }

        self.item = item
    }

    // MARK: Methods

    func onTap() async {
        guard
            #available(iOS 26.0, *),
            state == .tapToGenerate
        else {
            return
        }

        state = .generating

        let session = LanguageModelSession(
            instructions: instructions
        )

        let prompt = (
            [
                item.title.map {
                    "[Title] \($0)"
                },
                item.body.map {
                    "[Body] \($0)"
                }
            ] +
            item
                .comments
                .lazy
                .filter {
                    $0.depth == .zero
                }
                .prefix(10)
                .compactMap {
                    $0.item.body.map {
                        "[Comment] \($0)"
                    }
                }
        )
            .compacted()
            .joined(separator: "\n")

        do {
            for try await response in session.streamResponse(
                to: prompt
            ) {
                state = .generated(summary: response.content)
            }
        } catch {
            state = .generated(summary: nil)
        }
    }
}

// MARK: - Private extension

private extension DiscussionAtAGlanceViewModel {

    // MARK: Properties

    var instructions: String {
        let locale = Locale.current

        var instructions = """
        Summarize the comments of a Hacker News story provided in \
        the prompt. Do not quote comments directly and do not refer \
        to the order of the comments (e.g., "first comment", \
        "second comment"). Do not use enumerations, lists, or \
        numbering. When writing the summary, do not mention that \
        the comments are from Hacker News. Focus only on what \
        people discuss in the comments, not on the story itself. \
        Respond as briefly as possible.
        """

        instructions += {
            if Locale.Language(identifier: "en_US").isEquivalent(
                to: locale.language
            ) {
                ""
            } else {
                " The person's locale is \(locale.identifier)."
            }
        }()

        return instructions
    }
}
