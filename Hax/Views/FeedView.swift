//
//  FeedView.swift
//  Hax
//
//  Created by Luis Fariña on 8/5/22.
//

import SwiftUI

struct FeedView: View {

    // MARK: Properties

    @StateObject var viewModel: FeedViewModel

    // MARK: Body

    var body: some View {
        Group {
            if viewModel.isLoading {
                ActivityIndicatorView()
            } else {
                List(enumeratedItems, id: \.1) { index, item in
                    ZStack {
                        Button {
                            viewModel.select(item: item)
                        } label: {
                            ItemRowView(
                                viewModel: ItemRowViewModel(
                                    in: .feed,
                                    index: index + 1,
                                    item: item,
                                    onNumberOfCommentsTap: {
                                        viewModel.pushItemView(
                                            for: item
                                        )
                                    }
                                )
                            )
                        }
                        NavigationLink(
                            tag: item,
                            selection: $viewModel.item
                        ) {
                            ItemView(
                                viewModel: ItemViewModel(item: item)
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
                        if item == viewModel.items.last {
                            viewModel.fetchMoreItems()
                        }
                    }
                }
            }
        }
        .alert(error: $viewModel.error)
        .listStyle(.plain)
        .navigationTitle(viewModel.feed.title)
        .onAppear {
            viewModel.fetchItems()
        }
        .safari(url: $viewModel.url)
    }
}

// MARK: - Private extension

private extension FeedView {

    var enumeratedItems: [(Int, Item)] {
        Array(zip(viewModel.items.indices, viewModel.items))
    }
}

// MARK: - Previews

struct FeedView_Previews: PreviewProvider {

    // MARK: Types

    private final class ViewModel: FeedViewModel {

        override func fetchItems() {
            items = (0...2).map { _ in
                .example
            }
            isLoading = false
        }

        override func fetchMoreItems() {
            // Do nothing
        }
    }

    // MARK: Previews

    static var previews: some View {
        NavigationView {
            FeedView(viewModel: ViewModel(feed: .top))
        }
    }
}
