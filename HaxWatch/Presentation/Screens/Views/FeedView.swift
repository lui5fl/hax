//
//  FeedView.swift
//  HaxWatch
//
//  Created by Luis Fariña on 24/9/24.
//

import SwiftUI
import WatchConnectivity

struct FeedView: View {

    // MARK: Properties

    @State var model: FeedViewModel
    @State private var alertIsPresented = false

    // MARK: Body

    var body: some View {
        Group {
            switch model.state {
            case .error(let error):
                ErrorView(error)
            case .loaded(let items):
                TabView {
                    ForEach(
                        Array(items.enumerated()),
                        id: \.1
                    ) { index, item in
                        ItemRowView(
                            model: ItemRowViewModel(
                                in: .feed,
                                index: index + 1,
                                item: item
                            )
                        )
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity,
                            alignment: .topLeading
                        )
                        .onTapGesture {
                            alertIsPresented = true
                            let session = WCSession.default

                            if session.activationState == .activated {
                                try? session.updateApplicationContext(
                                    ["id": item.id]
                                )
                            }
                        }
                        .padding()
                        .userActivity(
                            Constant.readItemUserActivity,
                            element: item
                        ) { item, userActivity in
                            userActivity.title = item.title
                            userActivity.userInfo = ["id": item.id]
                        }
                    }
                }
                .tabViewStyle(.verticalPage)
            case .loading:
                ProgressView()
            }
        }
        .alert(
            "Story sent to your iPhone",
            isPresented: $alertIsPresented
        ) {
            Button("OK") {
                alertIsPresented = false
            }
        } message: {
            Text("Open Hax on your iPhone to read it.")
        }
        .containerBackground(
            Color.accentColor.gradient,
            for: .navigation
        )
        .navigationTitle(model.feed.title)
        .onAppear {
            Task {
                await model.onAppear()
            }
        }
    }
}

#if DEBUG

// MARK: - Previews

// MARK: Types

private final class PreviewFeedViewModel: FeedViewModel {

    // MARK: Properties

    override var state: State {
        get {
            .loaded(items: [.example])
        }
        set {
            // Do nothing
        }
    }

    // MARK: Methods

    override func onAppear() async {
        // Do nothing
    }
}

// MARK: Previews

#Preview {
    NavigationStack {
        FeedView(model: PreviewFeedViewModel(feed: .top))
    }
}

#endif
