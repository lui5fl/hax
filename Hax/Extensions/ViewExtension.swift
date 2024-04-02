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
