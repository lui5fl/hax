//
//  TipJarView.swift
//  Hax
//
//  Created by Luis Fariña on 8/8/24.
//

import StoreKit
import SwiftUI

struct TipJarView: View {

    // MARK: Properties

    @State private var alertIsPresented = false
    @State private var error: Swift.Error?

    // MARK: Body

    var body: some View {
        ScrollView {
            VStack {
                Text(
                    """
                    All features of Hax are free, but if you want \
                    to support the development of the app, you can \
                    leave a tip.
                    """
                )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                StoreView(
                    ids: [
                        "consumable.tip.small",
                        "consumable.tip.medium",
                        "consumable.tip.large"
                    ]
                )
                .onInAppPurchaseCompletion { _, result in
                    if case .success(let purchaseResult) = result {
                        switch purchaseResult {
                        case .success(let verificationResult):
                            switch verificationResult {
                            case .unverified:
                                error = Error()
                            case .verified(let transaction):
                                alertIsPresented = true
                                await transaction.finish()
                            }
                        case .pending:
                            alertIsPresented = true
                        case .userCancelled:
                            fallthrough
                        @unknown default:
                            break
                        }
                    } else {
                        error = Error()
                    }
                }
                .productDescription(.hidden)
                .productViewStyle(.compact)
                .storeButton(.hidden, for: .cancellation)
            }

        }
        .alert(
            "Thank you very much!",
            isPresented: $alertIsPresented
        ) {
            Button("OK") {
                alertIsPresented = false
            }
        } message: {
            Text("I'm very happy that you like Hax!")
        }
        .alert(error: $error)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Tip Jar")
    }
}

// MARK: - Private extension

private extension TipJarView {

    // MARK: Types

    struct Error: LocalizedError {

        // MARK: Properties

        var errorDescription: String? {
            String(localized: "Error")
        }

        var recoverySuggestion: String? {
            String(localized: "There was an error making the purchase.")
        }
    }
}

// MARK: - Previews

#Preview {
    NavigationView {
        TipJarView()
    }
}
