//
//  SearchView.swift
//  Hax
//
//  Created by Luis Fariña on 25/8/24.
//

import SwiftUI

struct SearchView: View {

    // MARK: Properties

    @State var model: SearchViewModel
    @Binding var searchBarIsPresented: Bool
    @Binding var selectedItem: Item?
    @State private var url: IdentifiableURL?
    @State private var translationPopoverIsPresented = false
    @State private var textToBeTranslated = ""

    // MARK: Body

    var body: some View {
        ItemList(
            isLoading: model.isLoading,
            items: model.items,
            onItemAppear: nil,
            url: $url,
            selectedItem: $selectedItem,
            translationPopoverIsPresented: $translationPopoverIsPresented,
            textToBeTranslated: $textToBeTranslated
        )
        .alert(error: $model.error)
        .navigationDestination(item: $selectedItem) { item in
            ItemView(model: ItemViewModel(item: item))
        }
        .navigationTitle("Search")
        .safari(url: $url)
        .searchable(
            text: $model.text,
            isPresented: $searchBarIsPresented,
            prompt: "Title"
        )
        .translationPresentation(
            isPresented: $translationPopoverIsPresented,
            text: textToBeTranslated
        )
        .onSubmit(of: .search) {
            Task {
                await model.onSubmit()
            }
        }
    }
}

// MARK: - Previews

#Preview {
    NavigationStack {
        SearchView(
            model: SearchViewModel(),
            searchBarIsPresented: .constant(false),
            selectedItem: .constant(nil)
        )
    }
}
