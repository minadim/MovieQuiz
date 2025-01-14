//
//  ArrayTests.swift
//  MovieQuiz
//
//  Created by Nadin on 02.01.2025.
//
import XCTest
@testable import MovieQuiz

class ArrayTest: XCTestCase {
    func TestGetValueInRange() throws {
        let array = [1, 2, 3, 4, 5]
        let value = array[safe: 2]
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }
    func testGetValueOutOfRange() throws {
        let array = [1, 1, 2, 3, 5]
        let value = array[safe: 20]
        XCTAssertNil(value)
    }
}
