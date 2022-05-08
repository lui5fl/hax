//
//  ItemRowView.swift
//  Hax
//
//  Created by Luis Fariña on 8/5/22.
//

import SwiftUI

struct ItemRowView: View {

    // MARK: Properties

    let viewModel: ItemRowViewModel

    // MARK: Body

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(alignment: .center, spacing: 15) {
                if viewModel.shouldDisplayIndex {
                    Text(String(viewModel.index))
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .frame(width: 15, alignment: .trailing)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Divider()
                }
                VStack(alignment: .leading, spacing: 10) {
                    if let title = viewModel.item.title {
                        Text(title)
                            .font(titleFont)
                            .fontWeight(titleFontWeight)
                    }
                    if viewModel.shouldDisplayBody,
                       let body = viewModel.item.markdownBody {
                        Text(LocalizedStringKey(body))
                            .environment(
                                \.openURL,
                                 OpenURLAction { url in
                                     viewModel.onLinkTap?(url)
                                     return .handled
                                 }
                            )
                            .font(.subheadline)
                    }
                    HStack(spacing: 3) {
                        if let urlSimpleString = viewModel.item.urlSimpleString {
                            Text(urlSimpleString)
                                .lineLimit(1)
                            Text("⸱")
                        }
                        if viewModel.shouldDisplayAuthor,
                           let author = viewModel.item.author {
                            Text(author)
                            Text("⸱")
                        }
                        if viewModel.shouldDisplayScore,
                           let score = viewModel.item.score {
                            Text("\(Image(systemName: "arrow.up"))\(score)")
                            Text("⸱")
                        }
                        if let elapsedTimeString = viewModel.item.elapsedTimeString {
                            Text(elapsedTimeString)
                        }
                    }
                    .font(.footnote)
                    .foregroundColor(.secondary)
                }
                Spacer()
                if viewModel.shouldDisplayNumberOfComments,
                   let descendants = viewModel.item.descendants {
                    Text("\(Image(systemName: "bubble.right")) \(descendants)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .onTapGesture {
                            viewModel.onNumberOfCommentsTap?()
                        }
                }
            }
        }
        .padding(.vertical, 10)
    }
}

// MARK: - Private extension

private extension ItemRowView {

    /// The font for the title label.
    var titleFont: Font {
        viewModel.view == .feed ? .subheadline : .body
    }

    /// The weight of the font for the title label.
    var titleFontWeight: Font.Weight {
        viewModel.view == .feed ? .regular : .medium
    }
}

// MARK: - Previews

struct ItemRowView_Previews: PreviewProvider {

    // MARK: Properties

    static let views = ItemRowViewModel.View.allCases

    // MARK: Previews

    static var previews: some View {
        Preview {
            ForEach(views, id: \.self) { view in
                ItemRowView(
                    viewModel: ItemRowViewModel(
                        in: view,
                        item: .example
                    )
                )
                    .previewDisplayName(view.previewDisplayName)
            }
        }
        .previewLayout(.fixed(width: 400, height: 100))
    }
}
