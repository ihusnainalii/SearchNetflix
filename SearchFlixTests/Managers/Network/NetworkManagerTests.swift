//
//  NetworkManagerTests.swift
//  SearchFlixTests
//
//  Created by Husnian Ali on 27.02.2025.
//

import XCTest
@testable import SearchFlix

final class NetworkManagerTests: XCTestCase {
    // MARK: - Properties
    var mockNetworkManager: MockNetworkManager!

    // MARK: - Setup & Teardown
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
    }

    override func tearDown() {
        mockNetworkManager = nil
        super.tearDown()
    }

    func testMakeRequestSuccess() {
        // Given
        let json = """
        {
            "Search": [
                {
                    "Title": "Star Wars: Episode IV - A New Hope",
                    "Year": "1977",
                    "imdbID": "tt0076759",
                    "Type": "movie",
                    "Poster": "https://m.media-amazon.com/images/M/MV5BOGUwMDk0Y2MtNjBlNi00NmRiLTk2MWYtMGMyMDlhYmI4ZDBjXkEyXkFqcGc@._V1_SX300.jpg"
                },
                {
                    "Title": "Star Wars: Episode V - The Empire Strikes Back",
                    "Year": "1980",
                    "imdbID": "tt0080684",
                    "Type": "movie",
                    "Poster": "https://m.media-amazon.com/images/M/MV5BMTkxNGFlNDktZmJkNC00MDdhLTg0MTEtZjZiYWI3NGE5NWIwXkEyXkFqcGc@._V1_SX300.jpg"
                }
            ]
        }
        """.data(using: .utf8)!

        mockNetworkManager.mockData = json

        let expectation = self.expectation(description: "The API call should be successful.")

        // When
        mockNetworkManager.makeRequest(endpoint: .movieSearchTitle(movieSearchTitle: "Star Wars", page: "1"), type: SearchModel.self) { result in
            switch result {
            case .success(let searchResult):
                XCTAssertEqual(searchResult.search.count, 2, "The number of movies should be 2.")
                XCTAssertEqual(searchResult.search[0].title, "Star Wars: Episode IV - A New Hope", "The title of the first movie is incorrect.")
                XCTAssertEqual(searchResult.search[1].title, "Star Wars: Episode V - The Empire Strikes Back", "The title of the second movie is incorrect.")
                XCTAssertEqual(searchResult.search[0].year, "1977", "The year of the first movie is incorrect.")
                XCTAssertEqual(searchResult.search[1].year, "1980", "The year of the second movie is incorrect.")
                expectation.fulfill()
            case .failure:
                XCTFail("The API call that was supposed to succeed failed.")
            }
        }

        // Then
        XCTAssertTrue(mockNetworkManager.makeRequestCalled, "The makeRequest method was not called.")

        wait(for: [expectation], timeout: 2.0)
    }

    func testMakeRequestFailure() {
        // Given
        mockNetworkManager.shouldReturnError = true

        let expectation = self.expectation(description: "The API call should fail.")

        // When
        mockNetworkManager.makeRequest(endpoint: .movieSearchTitle(movieSearchTitle: "Star Wars", page: "1"), type: SearchModel.self) { result in
            switch result {
            case .success:
                XCTFail("The API call that was supposed to fail succeeded.")
            case .failure(let error):
                XCTAssertEqual(error, .unableToComplete, "The returned error code is incorrect.")
                expectation.fulfill()
            }
        }

        // Then
        XCTAssertTrue(mockNetworkManager.makeRequestCalled, "The makeRequest method was not called.")

        wait(for: [expectation], timeout: 2.0)
    }
}

