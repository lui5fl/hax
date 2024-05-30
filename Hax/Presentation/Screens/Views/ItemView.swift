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

    // MARK: Body

    var body: some View {
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
                        }
                    )
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
                    }
                    .id(comment)
                    .onTapGesture {
                        model.onCommentTap(comment: comment)
                    }
                }
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
            model.onViewAppear()
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
    }
}

// MARK: - Previews

struct ItemView_Previews: PreviewProvider {

    // MARK: Types

    private final class Model: ItemViewModel {

        override func onViewAppear() {
            comments = (0...2).map { number in
                .example(id: number, depth: number)
            }
            isLoading = false
        }
    }

    // MARK: Previews

    static var previews: some View {
        NavigationStack {
            ItemView(model: Model(item: .example))
        }
    }
}
