//
//  DateExtensionTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 21/12/22.
//

import Foundation
import Testing
@testable import Hax

struct DateExtensionTests {

    // MARK: Tests

    @Test func elapsedTimeString_givenElapsedTimeIs59Seconds() throws {
        // Given
        let sut = try currentDate(adding: .second, value: -59)

        // When
        let elapsedTimeString = sut.elapsedTimeString()

        // Then
        #expect(elapsedTimeString == "59s")
    }

    @Test func elapsedTimeString_givenElapsedTimeIs1Minute() throws {
        // Given
        let sut = try currentDate(adding: .minute, value: -1)

        // When
        let elapsedTimeString = sut.elapsedTimeString()

        // Then
        #expect(elapsedTimeString == "1m")
    }

    @Test func elapsedTimeString_givenElapsedTimeIs1Hour() throws {
        // Given
        let sut = try currentDate(adding: .hour, value: -1)

        // When
        let elapsedTimeString = sut.elapsedTimeString()

        // Then
        #expect(elapsedTimeString == "1h")
    }

    @Test func elapsedTimeString_givenElapsedTimeIs1Day() throws {
        // Given
        let sut = try currentDate(adding: .day, value: -1)

        // When
        let elapsedTimeString = sut.elapsedTimeString()

        // Then
        #expect(elapsedTimeString == "1d")
    }

    @Test func elapsedTimeString_givenElapsedTimeIs31Days() throws {
        // Given
        let sut = try currentDate(adding: .day, value: -31)

        // When
        let elapsedTimeString = sut.elapsedTimeString()

        // Then
        #expect(elapsedTimeString == "1mo")
    }

    @Test func elapsedTimeString_givenElapsedTimeIs1Year() throws {
        // Given
        let sut = try currentDate(adding: .year, value: -1)

        // When
        let elapsedTimeString = sut.elapsedTimeString()

        // Then
        #expect(elapsedTimeString == "1y")
    }
}

// MARK: - Private extension

private extension DateExtensionTests {

    // MARK: Methods

    func currentDate(
        adding component: Calendar.Component,
        value: Int
    ) throws -> Date {
        try #require(
            Calendar.current.date(
                byAdding: component,
                value: value,
                to: .now
            )
        )
    }
}
