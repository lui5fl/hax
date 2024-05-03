//
//  FilterView.swift
//  Hax
//
//  Created by Luis Fariña on 13/4/24.
//

import SwiftData
import SwiftUI

struct FilterView: View {

    // MARK: Properties

    @Environment(\.modelContext) var modelContext
    @Query var keywordFilters: [KeywordFilter]
    @Query var userFilters: [UserFilter]
    @State var addNewKeywordFilterAlertIsPresented = false
    @State var addNewKeywordFilterAlertText = ""
    @State var addNewUserFilterAlertIsPresented = false
    @State var addNewUserFilterAlertText = ""

    // MARK: Body

    var body: some View {
        Form {
            section(
                "Keywords",
                models: keywordFilters,
                addNewFilterAlertIsPresented: $addNewKeywordFilterAlertIsPresented,
                text: \.keyword
            )
            section(
                "Users",
                models: userFilters,
                addNewFilterAlertIsPresented: $addNewUserFilterAlertIsPresented,
                text: \.user
            )
        }
        .alert(
            "Add New Keyword Filter",
            message: "Input the keyword that, if present in stories or comments, these should be filtered out.",
            isPresented: $addNewKeywordFilterAlertIsPresented,
            text: $addNewKeywordFilterAlertText
        ) { keyword in
            modelContext.insert(KeywordFilter(keyword: keyword.localizedLowercase))
        }
        .alert(
            "Add New User Filter",
            message: "Input the user whose stories and comments you want to filter out.",
            isPresented: $addNewUserFilterAlertIsPresented,
            text: $addNewUserFilterAlertText
        ) { user in
            modelContext.insert(UserFilter(user: user))
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Filters")
    }
}

// MARK: - Private extensions

@MainActor
private extension FilterView {

    // MARK: Methods

    func section<T: PersistentModel>(
        _ titleKey: LocalizedStringKey,
        models: [T],
        addNewFilterAlertIsPresented: Binding<Bool>,
        text: @escaping (T) -> String
    ) -> some View {
        Section(titleKey) {
            List {
                ForEach(models) { model in
                    Text(text(model))
                }
                .onDelete { indexSet in
                    delete(models, at: indexSet)
                }
                Button {
                    addNewFilterAlertIsPresented.wrappedValue = true
                } label: {
                    Label("Add New Filter", systemImage: "plus")
                }
            }
        }
    }

    func delete<T: PersistentModel>(
        _ models: [T],
        at indexSet: IndexSet
    ) {
        for index in indexSet {
            modelContext.delete(models[index])
        }
    }
}

private extension View {

    // MARK: Methods

    func alert(
        _ titleKey: LocalizedStringKey,
        message: LocalizedStringKey,
        isPresented: Binding<Bool>,
        text: Binding<String>,
        onOKButtonTrigger: @escaping (String) -> Void
    ) -> some View {
        alert(titleKey, isPresented: isPresented) {
            TextField(String(""), text: text)
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)
            Button("Cancel") {
                text.wrappedValue = ""
            }
            Button("OK") {
                if !text.wrappedValue.isEmpty {
                    onOKButtonTrigger(text.wrappedValue)
                }
                text.wrappedValue = ""
            }
            .keyboardShortcut(.defaultAction)
        } message: {
            Text(message)
        }
    }
}

// MARK: - Previews

#Preview {
    NavigationStack {
        FilterView()
    }
    .modelContainer(
        for: [KeywordFilter.self, UserFilter.self],
        inMemory: true
    ) { result in
        if let modelContext = try? result.get().mainContext {
            modelContext.insert(KeywordFilter(keyword: "keyword"))
            modelContext.insert(UserFilter(user: "user"))
        }
    }
}
