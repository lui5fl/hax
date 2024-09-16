//
//  RequestRowView.swift
//  Hax
//
//  Created by Luis Fariña on 11/2/25.
//

#if DEBUG

import SwiftUI

struct RequestRowView: View {

    // MARK: Properties

    let statusCode: Int?
    let host: String?
    let path: String?
    let time: String

    // MARK: Body

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 5) {
                Group {
                    if let statusCode {
                        Text(
                            "\(Image(systemName: systemImage(statusCode: statusCode))) \(statusCode)",
                            tableName: ""
                        )
                        .foregroundStyle(
                            color(statusCode: statusCode)
                        )
                    }
                    if let host {
                        Text(host)
                    }
                }
                .bold()
                if let path {
                    Text(path)
                }
            }
            Text(time)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Private extension

private extension RequestRowView {

    // MARK: Methods

    func systemImage(statusCode: Int) -> String {
        switch statusCode {
        case 100..<200:
            "info.circle.fill"
        case 200..<300:
            "checkmark.circle.fill"
        case 300..<400:
            "arrow.right.circle.fill"
        case 400..<500:
            "exclamationmark.circle.fill"
        case 500..<600:
            "xmark.circle.fill"
        default:
            "questionmark.circle.fill"
        }
    }

    func color(statusCode: Int) -> Color {
        switch statusCode {
        case 200..<300:
            .green
        case 300..<400:
            .yellow
        case 400..<500:
            .orange
        case 500..<600:
            .red
        default:
            .gray
        }
    }
}

// MARK: - Previews

#Preview {
    RequestRowView(
        statusCode: 200,
        host: "hacker-news.firebaseio.com",
        path: "/v0/item/1.json",
        time: "9:41:42"
    )
}

#endif
