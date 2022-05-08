//
//  ItemView.swift
//  Hax
//
//  Created by Luis Fariña on 8/5/22.
//

import SwiftUI

struct ItemView: View {

    // MARK: Properties

    @StateObject var viewModel: ItemViewModel

    // MARK: Body

    var body: some View {
        List {
            Button {
                viewModel.url = IdentifiableURL(viewModel.item.url)
            } label: {
                ItemRowView(
                    viewModel: ItemRowViewModel(
                        in: .item,
                        item: viewModel.item,
                        onLinkTap: { url in
                            viewModel.url = IdentifiableURL(url)
                        }
                    )
                )
            }
            if viewModel.isLoading {
                HStack {
                    Spacer()
                    ActivityIndicatorView()
                    Spacer()
                }
                .padding()
            } else {
                ForEach(viewModel.comments) { comment in
                    CommentRowView(
                        viewModel: CommentRowViewModel(
                            comment: comment,
                            onLinkTap: { url in
                                viewModel.url = IdentifiableURL(url)
                            }
                        )
                    )
                        .onAppear {
                            if comment.id == viewModel.comments.last?.id {
                                viewModel.fetchMoreComments()
                            }
                        }
                        .onTapGesture {
                            viewModel.toggle(comment: comment)
                        }
                }
            }
        }
        .alert(error: $viewModel.error)
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(viewModel.title)
        .onAppear {
            viewModel.fetchItem()
        }
        .safari(url: $viewModel.url)
        .toolbar {
            if let _ = viewModel.item.url {
                Button {
                    viewModel.shareItem()
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }
}

// MARK: - Previews

struct ItemView_Previews: PreviewProvider {

    // MARK: Types

    private final class ViewModel: ItemViewModel {

        override func fetchItem() {
            comments = (0...2).map { number in
                .example(id: number, depth: number)
            }
            isLoading = false
        }

        override func fetchMoreComments() {
            // Do nothing
        }
    }

    // MARK: Previews

    static var previews: some View {
        Preview {
            NavigationView {
                ItemView(viewModel: ViewModel(item: .example))
            }
        }
    }
}
