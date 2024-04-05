//
//  DateExtensionTests.swift
//  HaxTests
//
//  Created by Luis Fariña on 21/12/22.
//

import XCTest
@testable import Hax

final class DateExtensionTests: XCTestCase {

    // MARK: Tests

    func testElapsedTimeString_givenElapsedTimeIs59Seconds() throws {
        // Given
        let sut = try currentDate(adding: .second, value: -59)

        // When
        let elapsedTimeString = sut.elapsedTimeString()

        // Then
        XCTAssertEqual(elapsedTimeString, "59s")
    }

    func testElapsedTimeString_givenElapsedTimeIs1Minute() throws {
        // Given
        let sut = try currentDate(adding: .minute, value: -1)

        // When
        let elapsedTimeString = sut.elapsedTimeString()

        // Then
        XCTAssertEqual(elapsedTimeString, "1m")
    }

    func testElapsedTimeString_givenElapsedTimeIs1Hour() throws {
        // Given
        let sut = try currentDate(adding: .hour, value: -1)

        // When
        let elapsedTimeString = sut.elapsedTimeString()

        // Then
        XCTAssertEqual(elapsedTimeString, "1h")
    }

    func testElapsedTimeString_givenElapsedTimeIs1Day() throws {
        // Given
        let sut = try currentDate(adding: .day, value: -1)

        // When
        let elapsedTimeString = sut.elapsedTimeString()

        // Then
        XCTAssertEqual(elapsedTimeString, "1d")
    }

    func testElapsedTimeString_givenElapsedTimeIs31Days() throws {
        // Given
        let sut = try currentDate(adding: .day, value: -31)

        // When
        let elapsedTimeString = sut.elapsedTimeString()

        // Then
        XCTAssertEqual(elapsedTimeString, "1mo")
    }

    func testElapsedTimeString_givenElapsedTimeIs1Year() throws {
        // Given
        let sut = try currentDate(adding: .year, value: -1)

        // When
        let elapsedTimeString = sut.elapsedTimeString()

        // Then
        XCTAssertEqual(elapsedTimeString, "1y")
    }
}

// MARK: - Private extension

private extension DateExtensionTests {

    // MARK: Methods

    func currentDate(
        adding component: Calendar.Component,
        value: Int
    ) throws -> Date {
        try XCTUnwrap(
            Calendar.current.date(
                byAdding: component,
                value: value,
                to: .now
            )
        )
    }
}
