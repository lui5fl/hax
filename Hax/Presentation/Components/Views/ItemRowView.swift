//
//  ItemRowView.swift
//  Hax
//
//  Created by Luis Fariña on 8/5/22.
//

import SwiftUI

struct ItemRowView<Model: ItemRowViewModelProtocol>: View {

    // MARK: Properties

    let model: Model

    // MARK: Body

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(alignment: .center, spacing: 15) {
                if model.shouldDisplayIndex {
                    Text(String(model.index))
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .frame(width: 15, alignment: .trailing)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Divider()
                }
                VStack(alignment: .leading, spacing: 10) {
                    if let title = model.item.title {
                        Text(title)
                            .font(titleFont)
                            .fontWeight(titleFontWeight)
                    }
                    if model.shouldDisplayBody,
                       let body = model.item.markdownBody {
                        Text(LocalizedStringKey(body))
                            .environment(
                                \.openURL,
                                 OpenURLAction { url in
                                     model.onLinkTap?(url) ?? .systemAction
                                 }
                            )
                            .font(.subheadline)
                    }
                    HStack(spacing: 3) {
                        if let urlSimpleString = model.item.urlSimpleString {
                            Text(urlSimpleString)
                                .lineLimit(1)
                            Text(verbatim: "⸱")
                        }
                        if model.shouldDisplayAuthor,
                           let author = model.item.author {
                            Text(author)
                            Text(verbatim: "⸱")
                        }
                        if model.shouldDisplayScore,
                           let score = model.item.score {
                            Text(
                                "\(Image(systemName: "arrow.up"))\(score)",
                                tableName: ""
                            )
                            Text(verbatim: "⸱")
                        }
                        if let elapsedTimeString = model.item.elapsedTimeString {
                            Text(elapsedTimeString)
                        }
                    }
                    .font(.footnote)
                    .foregroundColor(.secondary)
                }
                Spacer()
                if model.shouldDisplayNumberOfComments,
                   let descendants = model.item.descendants {
                    Text(
                        "\(Image(systemName: "bubble.right")) \(descendants)",
                        tableName: ""
                    )
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .onTapGesture {
                            model.onNumberOfCommentsTap?()
                        }
                }
            }
        }
        .padding(.vertical, 5)
    }
}

// MARK: - Private extension

private extension ItemRowView {

    /// The font for the title label.
    var titleFont: Font {
        model.view == .feed ? .subheadline : .body
    }

    /// The weight of the font for the title label.
    var titleFontWeight: Font.Weight {
        model.view == .feed ? .regular : .medium
    }
}

// MARK: - Previews

struct ItemRowView_Previews: PreviewProvider {

    // MARK: Properties

    static let views = ItemRowViewModelView.allCases

    // MARK: Previews

    static var previews: some View {
        ForEach(views, id: \.self) { view in
            ItemRowView(
                model: ItemRowViewModel(
                    in: view,
                    item: .example
                )
            )
            .previewDisplayName(view.previewDisplayName)
        }
        .previewLayout(.fixed(width: 400, height: 100))
    }
}
