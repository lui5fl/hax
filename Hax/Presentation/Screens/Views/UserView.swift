//
//  UserView.swift
//  Hax
//
//  Created by Luis Fariña on 31/5/24.
//

import SwiftUI

struct UserView<Model: UserViewModelProtocol>: View {

    // MARK: Properties

    @State var model: Model

    // MARK: Body

    var body: some View {
        Group {
            if let error = model.error {
                ErrorView(error)
            } else if let user = model.user {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text(user.id)
                                    .bold()
                                    .font(.title2)
                                    .textSelection(.enabled)
                                if let url = user.url {
                                    Spacer()
                                    ShareLink(item: url)
                                }
                            }
                            HStack(spacing: 3) {
                                Text(
                                    "User since \(user.creationDate.formatted(date: .numeric, time: .omitted))"
                                )
                                Text(verbatim: "⸱")
                                Text(
                                    "\(Image(systemName: "arrow.up"))\(user.karma)",
                                    tableName: ""
                                )
                            }
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        }
                        Divider()
                        if let markdownDescription = user.description {
                            Text(LocalizedStringKey(markdownDescription))
                                .environment(
                                    \.openURL,
                                     OpenURLAction(handler: model.onLinkTap)
                                )
                                .font(.subheadline)
                        } else {
                            Text("No description")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .italic()
                        }
                    }
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .topLeading
                    )
                    .padding(.horizontal, 20)
                    .padding(.vertical, 40)
                }
                .scrollBounceBehavior(.basedOnSize)
            } else {
                ActivityIndicatorView()
            }
        }
        .onAppear {
            Task {
                await model.onViewAppear()
            }
        }
        .safari(url: $model.url)
    }
}

// MARK: - Previews

#Preview {

    // MARK: Types

    struct PreviewUserViewModel: UserViewModelProtocol {

        // MARK: Properties

        var error: Error?

        let user: User? = User(
            id: "pg",
            creationDate: .now,
            karma: 157236,
            description: "Bug fixer."
        )

        var url: IdentifiableURL?

        // MARK: Methods

        func onViewAppear() {
            // Do nothing
        }

        func onLinkTap(url: URL) -> OpenURLAction.Result {
            .systemAction
        }
    }

    // MARK: Preview

    return UserView(model: PreviewUserViewModel())
}
