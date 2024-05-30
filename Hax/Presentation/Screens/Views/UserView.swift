//
//  UserView.swift
//  Hax
//
//  Created by Luis Fariña on 31/5/24.
//

import SwiftUI
import SwiftData

struct UserView<Model: UserViewModelProtocol>: View {

    // MARK: Properties

    @State var model: Model

    // MARK: Body

    var body: some View {
        Group {
            if let error = model.error {
                VStack(alignment: .center, spacing: 15) {
                    Image(systemName: "exclamationmark.circle")
                        .imageScale(.large)
                    Text(error.localizedDescription)
                        .multilineTextAlignment(.center)
                }
                .foregroundStyle(.secondary)
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
                                     OpenURLAction { url in
                                         model.url = IdentifiableURL(url)
                                         return .handled
                                     }
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

#if DEBUG

// MARK: - Previews

// MARK: Types

private struct PreviewUserViewModel: UserViewModelProtocol {
    var id: String = ""


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
}

// MARK: Types

#Preview {
    UserView(model: PreviewUserViewModel())
}

#endif
