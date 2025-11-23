//
//  DiscussionAtAGlanceView.swift
//  Hax
//
//  Created by Luis Fariña on 9/12/25.
//

import SwiftUI

struct DiscussionAtAGlanceView<
    Model: DiscussionAtAGlanceViewModelProtocol
>: View {

    // MARK: Properties

    @State var model: Model

    // MARK: Body

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Group {
                HStack(spacing: 5) {
                    Image(systemName: "apple.intelligence")
                    Text("Discussion at a glance")
                        .bold()
                        .textCase(.uppercase)
                }

                if model.state == .tapToGenerate {
                    Text(
                        """
                        Tap to generate a summary of the story's \
                        top comments
                        """
                    )
                } else if model.state == .generating {
                    Text("Generating summary…")
                }
            }
            .foregroundStyle(.secondary)

            if case .generated(let summary) = model.state {
                if let summary {
                    Text(LocalizedStringKey(summary))
                } else {
                    Text(
                        "There was an error generating the summary."
                    )
                    .foregroundStyle(.secondary)
                }
            }
        }
        .animation(.default, value: model.state)
        .font(.footnote)
        .listRowBackground(listRowBackground)
        .listRowSeparator(.hidden)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .onTapGesture {
            Task {
                await model.onTap()
            }
        }
    }
}

// MARK: - Private extension

private extension DiscussionAtAGlanceView {

    // MARK: Properties

    var listRowBackground: some View {
        AngularGradient(
            gradient: Gradient(
                colors: [
                    Color(
                        red: .zero,
                        green: 0.5,
                        blue: 1,
                        opacity: 0.8
                    ),
                    Color(
                        red: 0.5,
                        green: .zero,
                        blue: 1,
                        opacity: 0.7
                    ),
                    Color(
                        red: 1,
                        green: .zero,
                        blue: 0.5,
                        opacity: 0.6
                    ),
                    Color(
                        red: 1,
                        green: 0.5,
                        blue: .zero,
                        opacity: 0.8
                    ),
                    Color(
                        red: .zero,
                        green: 0.5,
                        blue: 1,
                        opacity: 0.8
                    )
                ]
            ),
            center: .center
        )
        .blur(radius: 50)
        .overlay(Color(UIColor.systemBackground).opacity(0.25))
        .clipped()
    }
}

#if DEBUG

// MARK: - Previews

// MARK: Types

private struct PreviewDiscussionAtAGlanceViewModel: DiscussionAtAGlanceViewModelProtocol {

    // MARK: Properties

    let state: DiscussionAtAGlanceViewState

    // MARK: Methods

    func onTap() async {
        // Do nothing
    }
}

// MARK: Previews

@available(iOS 26.0, *)
#Preview {
    List {
        DiscussionAtAGlanceView(
            model: PreviewDiscussionAtAGlanceViewModel(
                state: .tapToGenerate
            )
        )
        Spacer()
        DiscussionAtAGlanceView(
            model: PreviewDiscussionAtAGlanceViewModel(
                state: .generating
            )
        )
        Spacer()
        DiscussionAtAGlanceView(
            model: PreviewDiscussionAtAGlanceViewModel(
                state: .generated(
                    summary: """
                    Lorem ipsum dolor sit amet, consectetur \
                    adipiscing elit. Aliquam suscipit ullamcorper \
                    lacus, in fringilla nulla sagittis eget. Ut \
                    pretium semper ligula, non vestibulum neque \
                    posuere sit amet. Quisque ut eros finibus, \
                    dictum orci vel, vestibulum neque.
                    """
                )
            )
        )
        Spacer()
        DiscussionAtAGlanceView(
            model: PreviewDiscussionAtAGlanceViewModel(
                state: .generated(summary: nil)
            )
        )
    }
    .listStyle(.plain)
}

#endif
