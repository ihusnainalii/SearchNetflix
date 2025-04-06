//
//  HomeInteractorTests.swift
//  SearchFlixTests
//
//  Created by Husnian Ali on 4.03.2025.
//

import XCTest
@testable import SearchFlix

class HomeInteractorTests: XCTestCase {
    var interactor: HomeInteractor!
    var mockNetworkManager: MockNetworkManager!
    var mockOutput: MockHomeInteractorOutput!

    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        mockOutput = MockHomeInteractorOutput()
        interactor = HomeInteractor(networkService: mockNetworkManager)
        interactor.output = mockOutput
    }

    override func tearDown() {
        interactor = nil
        mockNetworkManager = nil
        mockOutput = nil
        super.tearDown()
    }

    func test_fetchMovies_success_searchType() {
        // Given
        let mockMovies = [
            MovieModel(title: "Star Wars: Episode IV - A New Hope", year: "1977", id: "tt0076759", type: "movie", image: "https://m.media-amazon.com/images/M/MV5BOGUwMDk0Y2MtNjBlNi00NmRiLTk2MWYtMGMyMDlhYmI4ZDBjXkEyXkFqcGc@._V1_SX300.jpg"),
            MovieModel(title: "Star Wars: Episode V - The Empire Strikes Back", year: "1980", id: "tt0080684", type: "movie", image: "https://m.media-amazon.com/images/M/MV5BMTkxNGFlNDktZmJkNC00MDdhLTg0MTEtZjZiYWI3MGE5NWIwXkEyXkFqcGc@._V1_SX300.jpg")
        ]

        let mockSearchModel = SearchModel(search: mockMovies)
        mockNetworkManager.mockData = try? JSONEncoder().encode(mockSearchModel)

        // When
        interactor.fetchMovies(type: .search, text: "Star", page: 1)

        // Then
        XCTAssertTrue(mockNetworkManager.makeRequestCalled, "Network request was not made.")
        XCTAssertTrue(mockOutput.isDidFetchMoviesCalled, "didFetchMovies was not called after fetchMovies.")
        XCTAssertEqual(mockOutput.fetchedMovies?.count, 2, "Expected number of movies does not match.")
        XCTAssertEqual(mockOutput.fetchedMovies?.first?.title, "Star Wars: Episode IV - A New Hope", "The first movie title does not match the expected value.")
        XCTAssertEqual(mockOutput.fetchType, .search, "FetchType does not match the expected value.")
        XCTAssertNil(mockOutput.fetchError, "An error was received when it was not expected.")
    }

    func test_fetchMovies_success_collectionType() {
        // Given
        let mockMovies = [
            MovieModel(title: "The King of Comedy", year: "1982", id: "tt0085794", type: "movie", image: "https://m.media-amazon.com/images/M/MV5BYTQxNGUwNmUtMDJhYy00ZjM1LWFjZjQtYmI5ZGY4YTZmZWQyXkEyXkFqcGc@._V1_SX300.jpg"),
            MovieModel(title: "A Midsummer Night's Sex Comedy", year: "1982", id: "tt0084329", type: "movie", image: "https://m.media-amazon.com/images/M/MV5BOTMxMTM0MTk3Nl5BMl5BanBnXkFtZTcwOTEyODI1NA@@._V1_SX300.jpg")
        ]
        
        let mockSearchModel = SearchModel(search: mockMovies)
        mockNetworkManager.mockData = try? JSONEncoder().encode(mockSearchModel)

        // When
        interactor.fetchMovies(type: .collection, text: nil, page: 1)

        // Then
        XCTAssertTrue(mockNetworkManager.makeRequestCalled, "Network request was not made.")
        XCTAssertTrue(mockOutput.isDidFetchMoviesCalled, "didFetchMovies was not called after fetchMovies.")
        XCTAssertEqual(mockOutput.fetchedMovies?.count, 2, "Expected number of movies does not match.")
        XCTAssertEqual(mockOutput.fetchedMovies?.first?.title, "The King of Comedy", "The first movie title does not match the expected value.")
        XCTAssertEqual(mockOutput.fetchType, .collection, "FetchType does not match the expected value.")
        XCTAssertNil(mockOutput.fetchError, "An error was received when it was not expected.")
    }

    func test_fetchMovies_failure() {
        // Given
        mockNetworkManager.shouldReturnError = true

        // When
        interactor.fetchMovies(type: .search, text: "Action", page: 1)

        // Then
        XCTAssertTrue(mockNetworkManager.makeRequestCalled, "Network request was not made.")
        XCTAssertTrue(mockOutput.isDidFailToFetchMoviesCalled, "didFailToFetchMovies was not called after fetchMovies.")
        XCTAssertNil(mockOutput.fetchedMovies, "Movies should be nil in case of a failed request.")
        XCTAssertNotNil(mockOutput.fetchError, "An error should have been received in case of a failed request.")
        XCTAssertEqual(mockOutput.fetchType, .search, "FetchType does not match the expected value.")
    }

}
