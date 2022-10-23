//
//  CommentRowView.swift
//  Hax
//
//  Created by Luis Fariña on 8/5/22.
//

import SwiftUI

struct CommentRowView: View {

    // MARK: Properties

    let viewModel: CommentRowViewModel

    // MARK: Body

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            if viewModel.comment.depth > 0 {
                Rectangle()
                    .cornerRadius(1.5)
                    .foregroundColor(lineColor)
                    .frame(width: 3)
                    .padding(.vertical, 5)
            }
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    if let author = viewModel.comment.item.author {
                        Text(author)
                            .bold()
                    }
                    Spacer()
                    if let elapsedTimeString = viewModel.comment.item.elapsedTimeString {
                        Text(elapsedTimeString)
                            .foregroundColor(.secondary)
                    }
                }
                if !viewModel.comment.isCollapsed,
                   let body = viewModel.comment.item.markdownBody {
                    Text(LocalizedStringKey(body))
                        .environment(
                            \.openURL,
                             OpenURLAction { url in
                                 viewModel.onLinkTap?(url)
                                 return .handled
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
        CGFloat(max(viewModel.comment.depth - 1, 0) * 10)
    }

    /// The color of the line on the leading side of the view.
    var lineColor: Color {
        let value = Double(viewModel.comment.depth) * 0.04

        return Color(
            red: 1 - value,
            green: 0.4 + value,
            blue: 0
        )
    }

    /// The opacity of the view.
    var opacity: Double {
        viewModel.comment.isCollapsed ? 0.4 : 1
    }
}

// MARK: - Previews

struct CommentView_Previews: PreviewProvider {

    // MARK: Properties

    static let isCollapsedValues = [false, true]
    static let depths = [0, 1, 2]

    // MARK: Previews

    static var previews: some View {
        ForEach(isCollapsedValues, id: \.self) { isCollapsed in
            ForEach(depths, id: \.self) { depth in
                CommentRowView(
                    viewModel: CommentRowViewModel(
                        comment: .example(
                            depth: depth,
                            isCollapsed: isCollapsed
                        )
                    )
                )
            }
        }
        .previewLayout(.fixed(width: 400, height: 50))
    }
}
