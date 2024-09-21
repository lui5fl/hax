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
    @Binding private(set) var selectedItem: Item?
    @State private var translationPopoverIsPresented = false
    @State private var textToBeTranslated = ""

    // MARK: Body

    var body: some View {
        ItemList(
            isLoading: model.isLoading,
            items: model.items,
            onItemAppear: { item in
                Task {
                    await model.onItemAppear(item: item)
                }
            },
            url: $model.url,
            selectedItem: $selectedItem,
            translationPopoverIsPresented: $translationPopoverIsPresented,
            textToBeTranslated: $textToBeTranslated
        )
        .alert(error: $model.error)
        .navigationTitle(model.feed.title)
        .onAppear {
            Task {
                await model.onViewAppear()
            }
        }
        .refreshable {
            await model.onRefreshRequest()
        }
        .safari(url: $model.url)
        .translationPresentation(
            isPresented: $translationPopoverIsPresented,
            text: textToBeTranslated
        )
    }
}

// MARK: - Previews

struct FeedView_Previews: PreviewProvider {

    // MARK: Types

    private final class Model: FeedViewModel {

        override func onViewAppear() async {
            items = (.zero ... 2).map { _ in
                .example
            }
            isLoading = false
        }

        override func onItemAppear(item: Item) async {
            // Do nothing
        }
    }

    // MARK: Previews

    static var previews: some View {
        NavigationStack {
            FeedView(
                model: Model(feed: .top),
                selectedItem: .constant(nil)
            )
        }
    }
}
