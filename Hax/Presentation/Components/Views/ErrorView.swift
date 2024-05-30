//
//  ErrorView.swift
//  Hax
//
//  Created by Luis Fariña on 3/7/24.
//

import SwiftUI

struct ErrorView: View {

    // MARK: Types

    enum Kind {

        // MARK: Cases

        case error(Error)
        case localizedStringKey(LocalizedStringKey)
    }

    // MARK: Properties

    let kind: Kind

    // MARK: Initialization

    init(_ error: Error) {
        kind = .error(error)
    }

    init(_ localizedStringKey: LocalizedStringKey) {
        kind = .localizedStringKey(localizedStringKey)
    }

    // MARK: Body

    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            Image(systemName: "exclamationmark.circle")
                .imageScale(.large)
            Group {
                switch kind {
                case .error(let error):
                    Text(error.localizedDescription)
                case .localizedStringKey(let localizedStringKey):
                    Text(localizedStringKey)
                }
            }
            .multilineTextAlignment(.center)
        }
        .foregroundStyle(.secondary)
    }
}

// MARK: - Previews

#Preview {
    ErrorView(HackerNewsServiceError.network)
}
