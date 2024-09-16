//
//  CommentRowView.swift
//  Hax
//
//  Created by Luis Fariña on 8/5/22.
//

import SwiftUI

struct CommentRowView<Model: CommentRowViewModelProtocol>: View {

    // MARK: Properties

    let model: Model

    // MARK: Body

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            if model.comment.depth > .zero {
                Rectangle()
                    .cornerRadius(1.5)
                    .foregroundColor(lineColor)
                    .frame(width: 3)
                    .padding(.vertical, 5)
            }
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    if let author = model.comment.item.author {
                        Text(author)
                            .bold()
                            .foregroundStyle(authorTextColor)
                            .onTapGesture {
                                model.onUserTap?()
                            }
                    }
                    Spacer()
                    if let elapsedTimeString = model.comment.item.elapsedTimeString {
                        Text(elapsedTimeString)
                            .foregroundColor(.secondary)
                    }
                }
                if !model.comment.isCollapsed,
                   let body = model.comment.item.markdownBody {
                    Text(LocalizedStringKey(body))
                        .environment(
                            \.openURL,
                             OpenURLAction { url in
                                 model.onLinkTap?(url) ?? .systemAction
                             }
                        )
                }
            }
            .font(.footnote)
        }
        .contentShape(Rectangle())
        .opacity(opacity)
        .padding(.leading, leadingPadding)
        .padding(.vertical, 5)
    }
}

// MARK: - Private extension

private extension CommentRowView {

    /// The leading padding to apply to the view.
    var leadingPadding: CGFloat {
        CGFloat(max(model.comment.depth - 1, .zero) * 10)
    }

    /// The color of the line on the leading side of the view.
    var lineColor: Color {
        let value = Double(model.comment.depth) * 0.04

        return Color(
            red: 1 - value,
            green: 0.4 + value,
            blue: .zero
        )
    }

    /// The opacity of the view.
    var opacity: Double {
        model.comment.isCollapsed ? 0.4 : 1
    }

    /// The color of the author text.
    var authorTextColor: Color {
        model.shouldHighlightAuthor ? .accentColor : .primary
    }
}

#if DEBUG

// MARK: - Previews

// MARK: Types

private struct PreviewCommentRowViewModel: CommentRowViewModelProtocol {

    // MARK: Properties

    let comment: Comment
    let onUserTap: OnUserTap? = nil
    let onLinkTap: OnLinkTap? = nil
    let shouldHighlightAuthor: Bool

    // MARK: Initialization

    init(
        comment: Comment = .example,
        shouldHighlightAuthor: Bool = false
    ) {
        self.comment = comment
        self.shouldHighlightAuthor = shouldHighlightAuthor
    }
}

// MARK: Properties

private let fixedLayoutPreviewTrait = PreviewTrait.fixedLayout(
    width: 400,
    height: 50
)

// MARK: Previews

#Preview("comment.depth == 0", traits: fixedLayoutPreviewTrait) {
    CommentRowView(model: PreviewCommentRowViewModel())
}

#Preview("comment.depth > 0", traits: fixedLayoutPreviewTrait) {
    CommentRowView(
        model: PreviewCommentRowViewModel(
            comment: .example(depth: 4)
        )
    )
}

#Preview(
    "comment.isCollapsed == true",
    traits: fixedLayoutPreviewTrait
) {
    CommentRowView(
        model: PreviewCommentRowViewModel(
            comment: .example(isCollapsed: true)
        )
    )
}

#Preview(
    "shouldHighlightAuthor == true",
    traits: fixedLayoutPreviewTrait
) {
    CommentRowView(
        model: PreviewCommentRowViewModel(
            shouldHighlightAuthor: true
        )
    )
}

#endif
