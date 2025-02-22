//
//  ItemList.swift
//  Hax
//
//  Created by Luis Fariña on 30/8/24.
//

import SwiftUI

struct ItemList: View {

    // MARK: Properties

    let isLoading: Bool
    let items: [Item]
    let onItemAppear: ((Item) -> Void)?
    @Binding var url: IdentifiableURL?
    @Binding var selectedItem: Item?
    @Binding var translationPopoverIsPresented: Bool
    @Binding var textToBeTranslated: String
    @Environment(ReadItems.self) private var readItems

    // MARK: Body

    var body: some View {
        Group {
            if isLoading {
                ActivityIndicatorView()
            } else {
                List(enumeratedItems, id: \.1) { index, item in
                    Button {
                        if let url = item.url {
                            self.url = IdentifiableURL(url)
                        } else {
                            selectedItem = item
                        }

                        readItems.add(item.id)
                    } label: {
                        ItemRowView(
                            model: ItemRowViewModel(
                                in: .feed,
                                index: index + 1,
                                item: item,
                                onNumberOfCommentsTap: {
                                    selectedItem = item
                                },
                                isRead: readItems.contains(item.id)
                            )
                        )
                    }
                    .contextMenu {
                        ShareView(
                            url: item.url,
                            hackerNewsURL: item.hackerNewsURL
                        )
                        TranslateButton(
                            text: item.title,
                            translationPopoverIsPresented: $translationPopoverIsPresented,
                            textToBeTranslated: $textToBeTranslated
                        )
                    }
                    .onAppear {
                        onItemAppear?(item)
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}

// MARK: - Private extension

private extension ItemList {

    // MARK: Properties

    var enumeratedItems: [(Int, Item)] {
        Array(zip(items.indices, items))
    }
}

// MARK: - Previews

#Preview {
    ItemList(
        isLoading: false,
        items: (.zero ... 2).map(Item.example),
        onItemAppear: nil,
        url: .constant(nil),
        selectedItem: .constant(nil),
        translationPopoverIsPresented: .constant(false),
        textToBeTranslated: .constant("")
    )
}
