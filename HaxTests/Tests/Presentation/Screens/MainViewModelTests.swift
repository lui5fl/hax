//
//  MainViewModelTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 2/3/24.
//

import Testing
@testable import Hax

@MainActor
struct MainViewModelTests {

    // MARK: Properties

    private let sut: MainViewModel
    private let defaultFeedServiceMock: DefaultFeedServiceMock

    // MARK: Initialization

    init() {
        defaultFeedServiceMock = DefaultFeedServiceMock()
        defaultFeedServiceMock.defaultFeedStub = .best
        sut = MainViewModel(defaultFeedService: defaultFeedServiceMock)
    }

    // MARK: Tests

    @Test func initialize() {
        #expect(sut.selectedFeed == .best)
        #expect(sut.selectedItem == nil)
        #expect(sut.presentedItem == nil)
        #expect(sut.presentedUser == nil)
        #expect(defaultFeedServiceMock.defaultFeedCallCount == 1)
    }
}
