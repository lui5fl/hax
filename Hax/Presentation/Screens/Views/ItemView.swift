//
//  ItemView.swift
//  Hax
//
//  Created by Luis Fariña on 8/5/22.
//

import SwiftUI

struct ItemView<Model: ItemViewModelProtocol>: View {

    // MARK: Properties

    @StateObject var model: Model
    @Environment(\.colorScheme) private var colorScheme
    @State private var translationPopoverIsPresented = false
    @State private var textToBeTranslated = ""

    // MARK: Body

    var body: some View {
        VStack(spacing: .zero) {
            List {
                Button {
                    model.url = IdentifiableURL(model.item.url)
                } label: {
                    ItemRowView(
                        model: ItemRowViewModel(
                            in: .item,
                            item: model.item,
                            onUserTap: {
                                model.onUserTap(item: model.item)
                            },
                            onLinkTap: { url in
                                model.onCommentLinkTap(url: url)
                            },
                            commentIsHighlighted: model.highlightedCommentId != nil
                        )
                    )
                }
                .contextMenu {
                    TranslateButton(
                        text: [
                            model.item.title,
                            model.item.markdownBody
                        ]
                            .compacted()
                            .joined(separator: "\n\n"),
                        translationPopoverIsPresented: $translationPopoverIsPresented,
                        textToBeTranslated: $textToBeTranslated
                    )
                }
                if model.isLoading {
                    HStack {
                        Spacer()
                        ActivityIndicatorView()
                        Spacer()
                    }
                    .padding()
                } else {
                    ForEach(model.comments) { comment in
                        CommentRowView(
                            model: CommentRowViewModel(
                                comment: comment,
                                item: model.item,
                                onUserTap: {
                                    model.onUserTap(item: comment.item)
                                },
                                onLinkTap: { url in
                                    model.onCommentLinkTap(url: url)
                                }
                            )
                        )
                        .contextMenu {
                            ShareView(
                                url: comment.item.url,
                                hackerNewsURL: comment.item.hackerNewsURL
                            )
                            TranslateButton(
                                text: comment.item.markdownBody,
                                translationPopoverIsPresented: $translationPopoverIsPresented,
                                textToBeTranslated: $textToBeTranslated
                            )
                        }
                        .id(comment)
                        .listRowBackground(
                            comment.id == model.highlightedCommentId
                            ? highlightedCommentColor
                            : nil
                        )
                        .onTapGesture {
                            model.onCommentTap(comment: comment)
                        }
                    }
                }
            }
            if model.highlightedCommentId != nil {
                VStack(spacing: .zero) {
                    Divider()
                    VStack {
                        Text("You're viewing a single comment")
                        Text("View all of the story's comments")
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.accentColor)
                    }
                    .multilineTextAlignment(.center)
                    .onTapGesture {
                        model.secondaryItem = model.item
                    }
                    .padding()
                }
                .background(highlightedCommentColor)
                .font(.footnote)
            }
        }
        .alert(error: $model.error)
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(item: $model.secondaryItem) { item in
            ItemView<ItemViewModel>(model: ItemViewModel(item: item))
                .toolbarRole(.editor)
        }
        .navigationTitle(model.title)
        .onAppear {
            Task {
                await model.onViewAppear()
            }

            ReadItems.shared.add(model.item.id)
        }
        .refreshable {
            await model.onRefreshRequest()
        }
        .safari(url: $model.url)
        .sheet(item: $model.user) { user in
            UserView(model: UserViewModel(id: user.string))
                .presentationDetents([.medium, .large])
        }
        .toolbar {
            ShareView(
                url: model.item.url,
                hackerNewsURL: model.item.hackerNewsURL
            )
        }
        .translationPresentation(
            isPresented: $translationPopoverIsPresented,
            text: textToBeTranslated
        )
    }
}

// MARK: - Private extension

private extension ItemView {

    // MARK: Properties

    var highlightedCommentColor: Color {
        Color.accentColor.opacity(colorScheme == .dark ? 0.15 : 0.1)
    }
}

// MARK: - Previews

#Preview {

    // MARK: Types

    final class Model: ItemViewModel {

        // MARK: Properties

        override var highlightedCommentId: Int? {
            .zero
        }

        // MARK: Methods

        override func onViewAppear() async {
            comments = (.zero ... 2).map { number in
                Comment.example(id: number, depth: number)
            }
            isLoading = false
        }
    }

    // MARK: Preview

    return NavigationStack {
        ItemView(model: Model(item: .example))
    }
}
