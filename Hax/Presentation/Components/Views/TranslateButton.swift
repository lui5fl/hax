//
//  TranslateButton.swift
//  Hax
//
//  Created by Luis Fariña on 17/8/24.
//

import SwiftUI
import Translation

struct TranslateButton: View {

    // MARK: Properties

    let text: String?
    @Binding var translationPopoverIsPresented: Bool
    @Binding var textToBeTranslated: String

    // MARK: Body

    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .phone,
           let text {
            Button {
                translationPopoverIsPresented = true
                textToBeTranslated = text
            } label: {
                Label(
                    "Translate…",
                    systemImage: "arrow.left.arrow.right"
                )
            }
        }
    }
}

// MARK: - Previews

#Preview {
    TranslateButton(
        text: "Text",
        translationPopoverIsPresented: .constant(false),
        textToBeTranslated: .constant("")
    )
}
