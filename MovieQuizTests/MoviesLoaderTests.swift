//
//  MoviesLoaderTests.swift
//  MovieQuiz
//
//  Created by Nadin on 03.01.2025.
//
import XCTest
@testable import MovieQuiz

class MoviesLoaderTests: XCTestCase {
    func testSuccessLoading() throws {
        // Given
        let stubNetworkClient = StubNetworkClient(emulateError: false)
        let loader = MoviesLoader()
        let expectation = expectation(description: "Loading expectation")
        // When
        loader.loadMovies { result in
            // Then
            switch result {
            case .success(let movies):
                XCTAssertEqual(movies.items.count, 2);
                expectation.fulfill()
            case .failure(_):
                XCTFail("Unexpected failure")
            }
        }
        waitForExpectations(timeout: 1)
    }
    func testFailureLoading() throws {
        // Given
        let stubNetworkClient = StubNetworkClient(emulateError: true)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        let expectation = expectation(description: "Loading expectation")
        // When
        loader.loadMovies { result in
            // Then
            switch result {
            case .success(_):
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertTrue(error is StubNetworkClient.TestError)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 1)
    }
}
