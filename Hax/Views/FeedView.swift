//
//  FeedView.swift
//  Hax
//
//  Created by Luis Fariña on 8/5/22.
//

import SwiftUI

struct FeedView<Model: FeedViewModelProtocol>: View {

    // MARK: Properties

    @StateObject var model: Model

    // MARK: Body

    var body: some View {
        Group {
            if model.isLoading {
                ActivityIndicatorView()
            } else {
                List(enumeratedItems, id: \.1) { index, item in
                    ZStack {
                        Button {
                            model.onItemButtonTrigger(item: item)
                        } label: {
                            ItemRowView(
                                model: ItemRowViewModel(
                                    in: .feed,
                                    index: index + 1,
                                    item: item,
                                    onNumberOfCommentsTap: {
                                        model.onNumberOfCommentsTap(
                                            item: item
                                        )
                                    }
                                )
                            )
                        }
                        NavigationLink(
                            tag: item,
                            selection: $model.selectedItem
                        ) {
                            ItemView(
                                model: ItemViewModel(item: item)
                            )
                        } label: {
                            EmptyView()
                        }.opacity(0).disabled(true)
                    }
                    .contextMenu {
                        if let url = item.url {
                            ShareLink(item: url)
                        }
                    }
                    .onAppear {
                        model.onItemAppear(item: item)
                    }
                }
            }
        }
        .alert(error: $model.error)
        .listStyle(.plain)
        .navigationTitle(model.feed.title)
        .onAppear {
            model.onViewAppear()
        }
        .safari(url: $model.url)
    }
}

// MARK: - Private extension

private extension FeedView {

    var enumeratedItems: [(Int, Item)] {
        Array(zip(model.items.indices, model.items))
    }
}

// MARK: - Previews

struct FeedView_Previews: PreviewProvider {

    // MARK: Types

    private final class Model: FeedViewModel {

        override func onViewAppear() {
            items = (0...2).map { _ in
                .example
            }
            isLoading = false
        }

        override func onItemAppear(item: Item) {
            // Do nothing
        }
    }

    // MARK: Previews

    static var previews: some View {
        NavigationView {
            FeedView(model: Model(feed: .top))
        }
    }
}
