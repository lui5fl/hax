//
//  ViewExtension.swift
//  Hax
//
//  Created by Luis Fariña on 18/5/22.
//

import SwiftUI

extension View {

    /// Presents an alert based on an error if it is different from nil.
    ///
    /// [Source](https://www.avanderlee.com/swiftui/error-alert-presenting)
    ///
    /// - Parameters:
    ///   - error: The error to base the alert on
    func alert(error: Binding<Error?>) -> some View {
        let wrappedLocalizedError = WrappedLocalizedError(
            error: error.wrappedValue
        )

        return alert(
            isPresented: .constant(wrappedLocalizedError != nil),
            error: wrappedLocalizedError,
            actions: { _ in
                Button("OK") {
                    error.wrappedValue = nil
                }
            },
            message: { error in
                if let recoverySuggestion = error.recoverySuggestion {
                    Text(recoverySuggestion)
                }
            }
        )
    }

    /// Wraps the view in a navigation stack and adds a dismiss button to the navigation bar.
    ///
    /// - Parameters:
    ///   - item: A binding to the source of truth for the sheet
    @MainActor
    func dismissable<Item>(item: Binding<Item?>) -> some View {
        NavigationStack {
            self
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            item.wrappedValue = nil
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                }
        }
    }

    /// Presents a `SFSafariViewController` instance if the provided URL is
    /// different from nil.
    ///
    /// - Parameters:
    ///   - url: The URL to navigate to
    func safari(url: Binding<IdentifiableURL?>) -> some View {
        fullScreenCover(item: url) { url in
            SafariView(url: url.url)
                .edgesIgnoringSafeArea(.all)
        }
    }

    /// Presents an alert with a text field and two buttons, a "cancel" button which clears the
    /// text, and a "OK" button which triggers a closure with the text field's content as a
    /// parameter.
    ///
    /// - Parameters:
    ///   - titleKey: The title of the alert
    ///   - message: The message of the alert
    ///   - isPresented: A binding that controls the presentation of the alert
    ///   - text: A binding to the text field's content
    ///   - onOKButtonTrigger: A closure that gets called when the "OK" button is
    ///     triggered, with the text field's content as a parameter
    func textFieldAlert(
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
                onOKButtonTrigger(text.wrappedValue)
                text.wrappedValue = ""
            }
            .keyboardShortcut(.defaultAction)
        } message: {
            Text(message)
        }
    }
}

private struct WrappedLocalizedError: LocalizedError {

    // MARK: Properties

    private let error: LocalizedError

    // MARK: Initialization

    init?(error: Error?) {
        guard let error = error as? LocalizedError else {
            return nil
        }

        self.error = error
    }

    // MARK: LocalizedError

    var errorDescription: String? {
        error.errorDescription
    }

    var recoverySuggestion: String? {
        error.recoverySuggestion
    }
}
