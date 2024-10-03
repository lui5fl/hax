//
//  MainView.swift
//  Hax
//
//  Created by Luis Fariña on 2/3/24.
//

import SwiftUI

struct MainView<Model: MainViewModelProtocol>: View {

    // MARK: Properties

    @State var model: Model
    @State private var searchBarIsPresented = false
    @State private var searchSelectedItem: Item?
    @State private var settingsNavigationPath = NavigationPath()

    // MARK: Body

    var body: some View {
        TabView(
            selection: Binding {
                model.selectedTab
            } set: { newValue, _ in
                if newValue == model.selectedTab {
                    switch model.selectedTab {
                    case .home:
                        model.selectedFeed = nil
                        model.selectedItem = nil
                    case .search:
                        if searchSelectedItem == nil {
                            searchBarIsPresented = true
                        } else {
                            searchSelectedItem = nil
                        }
                    case .settings:
                        settingsNavigationPath = NavigationPath()
                    }
                } else {
                    model.selectedTab = newValue
                }
            }
        ) {
            homeNavigationStack
            searchNavigationStack
            settingsNavigationStack
        }
        .fullScreenCover(item: $model.presentedItem) { item in
            ItemView(
                model: ItemViewModel(
                    item: item,
                    shouldFetchItem: item.title == nil
                )
            )
            .dismissable(item: $model.presentedItem)
            .id(item)
        }
        .sheet(item: $model.presentedUser) { user in
            UserView(model: UserViewModel(id: user.string))
                .presentationDetents([.medium, .large])
                .id(user.string)
        }
        .modifier(PadContentMargins())
    }
}

// MARK: - Private extension

@MainActor
private extension MainView {

    // MARK: Properties

    var homeNavigationStack: some View {
        NavigationStack {
            MenuView(
                model: MenuViewModel(),
                selectedFeed: $model.selectedFeed,
                presentedItem: $model.presentedItem,
                presentedUser: $model.presentedUser
            )
            .navigationDestination(
                item: $model.selectedFeed
            ) { feed in
                FeedView(
                    model: FeedViewModel(feed: feed),
                    selectedItem: $model.selectedItem
                )
                .id(feed)
                .navigationDestination(
                    item: $model.selectedItem
                ) { item in
                    ItemView(model: ItemViewModel(item: item))
                }
            }
        }
        .tabItem {
            Label("Home", systemImage: "house")
        }
        .tag(Tab.home)
    }

    var searchNavigationStack: some View {
        NavigationStack {
            SearchView(
                model: SearchViewModel(),
                searchBarIsPresented: $searchBarIsPresented,
                selectedItem: $searchSelectedItem
            )
        }
        .tabItem {
            Label("Search", systemImage: "magnifyingglass")
        }
        .tag(Tab.search)
    }

    var settingsNavigationStack: some View {
        NavigationStack(path: $settingsNavigationPath) {
            SettingsView(
                model: SettingsViewModel(),
                navigationPath: $settingsNavigationPath
            )
        }
        .tabItem {
            Label("Settings", systemImage: "gear")
        }
        .tag(Tab.settings)
    }
}

// MARK: - Previews

#Preview {
    MainView(model: MainViewModel())
}
