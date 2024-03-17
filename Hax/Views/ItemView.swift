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
                        onLinkTap: { url in
                            model.url = IdentifiableURL(url)
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
                            item: model.item
                        ) { url in
                            model.url = IdentifiableURL(url)
                        }
                    )
                    .id(comment)
                    .onAppear {
                        model.onCommentAppear(comment: comment)
                    }
                    .onTapGesture {
                        model.onCommentTap(comment: comment)
                    }
                }
            }
        }
        .alert(error: $model.error)
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(model.title)
        .onAppear {
            model.onViewAppear()
        }
        .safari(url: $model.url)
        .toolbar {
            if let url = model.item.url {
                ShareLink(item: url)
            }
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

        override func onCommentAppear(comment: Comment) {
            // Do nothing
        }
    }

    // MARK: Previews

    static var previews: some View {
        NavigationStack {
            ItemView(model: Model(item: .example))
        }
    }
}
