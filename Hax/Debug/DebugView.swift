//
//  DebugView.swift
//  Hax
//
//  Created by Luis Fariña on 6/2/25.
//

#if DEBUG

import SwiftUI

struct DebugView: View {

    // MARK: Properties

    @Environment(LoggedRequests.self) private var savedRequests
    @State private var text = ""

    // MARK: Body

    var body: some View {
        NavigationStack {
            Group {
                if savedRequests.requests.isEmpty {
                    ContentUnavailableView(
                        String("No Logged Requests"),
                        systemImage: "network"
                    )
                } else {
                    List(filteredRequests) { request in
                        RequestRowView(
                            statusCode: request.statusCode,
                            host: request.host,
                            path: request.path,
                            time: request.time
                        )
                        .contextMenu {
                            Menu(
                                String("Copy…"),
                                systemImage: "doc.on.doc"
                            ) {
                                Button(String("URL")) {
                                    UIPasteboard.general
                                        .url = request.request.url
                                }
                                Button(String("Response Body")) {
                                    UIPasteboard.general
                                        .string = request
                                        .responseBody
                                        .map(
                                            prettyPrintJSONIfPossible
                                        )
                                }
                            }
                        }
                    }
                    .searchable(
                        text: $text,
                        placement: .navigationBarDrawer(
                            displayMode: .always
                        )
                    )
                }
            }
            .navigationTitle(String("Requests"))
            .toolbar {
                Button(
                    String("Clear Requests"),
                    systemImage: "trash"
                ) {
                    savedRequests.removeAll()
                }
                .disabled(savedRequests.requests.isEmpty)
            }
        }
    }
}

// MARK: - Private extension

private extension DebugView {

    // MARK: Properties

    var filteredRequests: [LoggedRequests.Request] {
        let requests = Array(savedRequests.requests.reversed())

        guard !text.isEmpty else {
            return requests
        }

        let normalizedText = text.lowercased()

        return requests.filter { request in
            request.host?.lowercased().contains(
                normalizedText
            ) == true ||
            request.path?.lowercased().contains(
                normalizedText
            ) == true
        }
    }

    // MARK: Methods

    func prettyPrintJSONIfPossible(_ jsonString: String) -> String {
        guard
            let data = jsonString.data(using: .utf8),
            let jsonObject = try? JSONSerialization.jsonObject(
                with: data
            ),
            let prettyPrintedData = try? JSONSerialization.data(
                withJSONObject: jsonObject,
                options: .prettyPrinted
            ),
            let prettyPrintedJSONString = String(
                bytes: prettyPrintedData,
                encoding: .utf8
            )
        else {
            return jsonString
        }

        return prettyPrintedJSONString
    }
}

// MARK: - Previews

#Preview {
    NavigationStack {
        DebugView()
            .environment(LoggedRequests.shared)
    }
}

#endif
