//
//  ItemRowView.swift
//  HaxWatch
//
//  Created by Luis Fariña on 25/9/24.
//

import SwiftUI

struct ItemRowView: View {

    // MARK: Properties

    let model: ItemRowViewModel

    // MARK: Body

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 3) {
                if model.shouldDisplayIndex {
                    Text(verbatim: "#\(model.index)")
                    Text(verbatim: "⸱")
                }
                if model.shouldDisplayScore,
                   let score = model.item.score {
                    Text(
                        "\(Image(systemName: "arrow.up"))\(score)",
                        tableName: ""
                    )
                    Text(verbatim: "⸱")
                }
                if let elapsedTimeString = model.item.elapsedTimeString {
                    Text(elapsedTimeString)
                }
            }
            .foregroundColor(.secondary)
            .lineLimit(1)
            if let title = model.item.title {
                Text(title)
            }
            Spacer()
            if let urlSimpleString = model.item.urlSimpleString {
                Text(urlSimpleString)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
        }
    }
}

// MARK: - Previews

#Preview {
    ItemRowView(
        model: ItemRowViewModel(
            in: .feed,
            index: 42,
            item: .example
        )
    )
}
