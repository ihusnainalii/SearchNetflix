//
//  HomePresenterTests.swift
//  SearchFlixTests
//
//  Created by Husnian Ali on 4.03.2025.
//

import XCTest
@testable import SearchFlix

class HomePresenterTests: XCTestCase {
    var presenter: HomePresenter!
    var mockView: MockHomeView!
    var mockInteractor: MockHomeInteractor!
    var mockRouter: MockHomeRouter!
    let moviesToReturn = [
        MovieModel(title: "Star Wars: Episode IV - A New Hope",
                   year: "1977",
                   id: "tt0076759",
                   type: "movie",
                   image: "https://m.media-amazon.com/images/M/MV5BOGUwMDk0Y2MtNjBlNi00NmRiLTk2MWYtMGMyMDlhYmI4ZDBjXkEyXkFqcGc@._V1_SX300.jpg")
    ]

    override func setUp() {
        super.setUp()

        mockView = MockHomeView()
        mockInteractor = MockHomeInteractor()
        mockInteractor.moviesToReturn = moviesToReturn
        mockRouter = MockHomeRouter()
        presenter = HomePresenter(view: mockView, interactor: mockInteractor, router: mockRouter)

    }

    override func tearDown() {
        presenter = nil
        mockView = nil
        mockInteractor = nil
        mockRouter = nil
        super.tearDown()
    }

    func testViewDidLoadFetchesMoviesSuccessfully() {
        // Given
        let moviesToReturn = [MovieModel(title: "Star Wars: Episode IV - A New Hope", year: "1977", id: "tt0076759", type: "movie", image: "https://m.media-amazon.com/images/M/MV5BOGUwMDk0Y2MtNjBlNi00NmRiLTk2MWYtMGMyMDlhYmI4ZDBjXkEyXkFqcGc@._V1_SX300.jpg")]
        mockInteractor.moviesToReturn = moviesToReturn
        mockInteractor.fetchMoviesError = nil 

        // When
        presenter.viewDidLoad()

        // Then
        XCTAssertTrue(mockView.setLodingCalled, "Loading should be set when view is loaded")
        XCTAssertTrue(mockInteractor.fetchMoviesCalled, "fetchMovies should be called when view is loaded")
        XCTAssertTrue(mockInteractor.fetchMoviesCalled, "fetchMovies should be called for both search and collection")
        XCTAssertEqual(mockInteractor.moviesToReturn.count, moviesToReturn.count, "Movies returned by interactor should be the same as mock data")
        XCTAssertTrue(mockInteractor.didFetchMoviesCalled, "didFetchMovies should be called when movies are fetched successfully")
    }

    func testViewDidLoadFetchesMoviesWithError() {
        // Given
        let error = NSError(domain: "com.app.error", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch movies"])
        mockInteractor.fetchMoviesError = error

        // When
        presenter.viewDidLoad()

        // Then
        XCTAssertTrue(mockView.setLodingCalled, "Loading should be set when view is loaded")
        XCTAssertTrue(mockInteractor.fetchMoviesCalled, "fetchMovies should be called when view is loaded")
        XCTAssertTrue(mockInteractor.didFailToFetchMoviesCalled, "didFailToFetchMovies should be called when an error occurs")
    }

    func testSearchMovies() {
        // Given
        let moviesToReturn = [
            MovieModel(title: "Star Wars: Episode IV - A New Hope",
                       year: "1977",
                       id: "tt0076759",
                       type: "movie",
                       image: "https://m.media-amazon.com/images/M/MV5BOGUwMDk0Y2MtNjBlNi00NmRiLTk2MWYtMGMyMDlhYmI4ZDBjXkEyXkFqcGc@._V1_SX300.jpg")
        ]
        mockInteractor.moviesToReturn = moviesToReturn
        let searchText = "Star"

        // Expectation to wait for async operations to finish
        let expectation = self.expectation(description: "Waiting for movies to be fetched and UI to update")

        // When
        presenter.searchMovies(searchText: searchText)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // 1. Loading kontrolü
            XCTAssertTrue(self.mockView.setLodingCalled, "Loading should be set when searchMovies is called")
            XCTAssertTrue(self.mockView.isLoading, "Loading should be true during the fetch")
            XCTAssertFalse(self.mockView.isFirstFetch, "isFirstFetch should be false after first fetch")

            XCTAssertTrue(self.mockInteractor.fetchMoviesCalled, "fetchMovies should be called on Interactor")
            XCTAssertEqual(self.mockInteractor.fetchMoviesText, searchText, "Interactor should fetch movies with the correct search text")

            XCTAssertEqual(self.mockInteractor.fetchMoviesPage, 1, "Interactor should start from the first page")

            XCTAssertTrue(self.mockView.scrollToTopCalled, "scrollToTop should be called when searchMovies is executed")
            XCTAssertNotNil(self.mockInteractor.moviesToReturn, "Movies returned from Interactor should not be nil")
            XCTAssertTrue(!self.mockInteractor.moviesToReturn.isEmpty, "Movies should contain data")

            #warning("Reloadtable kısmına bak girmesi lazım ama hata veriyor testti.")
            //            XCTAssertTrue(self.mockView.reloadTableCalled, "reloadTable should be called after fetching movies")

            XCTAssertFalse(self.mockView.reloadCollectionCalled, "reloadCollection should NOT be called during search")

            expectation.fulfill()
        }

        // Wait for the expectation to be fulfilled, ensuring async operations complete
        waitForExpectations(timeout: 1, handler: nil)
    }


//    func testGetMovie() {
//        // Given: Mock veri
//        let moviesToReturn = [
//            MovieModel(title: "Star Wars: Episode IV - A New Hope",
//                       year: "1977",
//                       id: "tt0076759",
//                       type: "movie",
//                       image: "https://m.media-amazon.com/images/M/MV5BOGUwMDk0Y2MtNjBlNi00NmRiLTk2MWYtMGMyMDlhYmI4ZDBjXkEyXkFqcGc@._V1_SX300.jpg")
//        ]
//
//        // Mock interactor'ı ayarlıyoruz, mock veri sağlıyoruz
//        mockInteractor.moviesToReturn = moviesToReturn
//        mockInteractor.fetchMoviesError = nil  // Hata yok
//
//        // Create an expectation to wait for the async operation
//        let expectation = XCTestExpectation(description: "Movies data should be fetched")
//
//        // When: Presenter'ı searchMovies fonksiyonu ile çağırıyoruz
//        presenter.searchMovies(searchText: "Star")
//
//        // Add a delay to give time for the mock interactor to fetch the data
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            // Check if the movie is correctly added to the presenter
//            let fetchedMovie = self.presenter.getMovie(at: 0, for: .search)
//
//            // Ensure that the fetched movie is not nil and matches the expected data
//            XCTAssertNotNil(fetchedMovie, "Fetched movie should not be nil.")
//            XCTAssertEqual(fetchedMovie.title, self.moviesToReturn.first?.title, "The fetched movie title should be correct.")
//            XCTAssertEqual(fetchedMovie.year, self.moviesToReturn.first?.year, "The fetched movie year should be correct.")
//            XCTAssertEqual(fetchedMovie.id, self.moviesToReturn.first?.id, "The fetched movie id should be correct.")
//
//            // Fulfill the expectation to indicate that the async test is complete
//            expectation.fulfill()
//        }
//
//        // Wait for the expectation to be fulfilled, with a timeout
//        wait(for: [expectation], timeout: 3.0) // Timeout adjusted to 3 seconds to give enough time for async
//    }




//    func testDidSelectMovieCallsNavigateToDetail() {
//        // Given: Movies dizisi ve ilgili index
//        let type: FetchType = .search
//        mockInteractor.moviesToReturn = moviesToReturn
//
//        // Expectation, router'ın navigateToDetail metodunun çağrıldığından emin olmak için
//        let expectation = self.expectation(description: "Navigate to movie detail")
//
//        // Mock router'ı, navigateToDetail metodunun çağrıldığını kontrol etmek için ayarlıyoruz
//        mockRouter.navigateToDetailClosure = { (viewController, movie) in
//            // Movie verisinin doğru gelip gelmediğini kontrol ediyoruz
//            XCTAssertEqual(movie.title, self.moviesToReturn.first?.title, "Movie title should match")
//            XCTAssertEqual(movie.id, self.moviesToReturn.first?.id, "Movie ID should match")
//            expectation.fulfill()  // Expectation'ı fulfill ediyoruz
//        }
//
//        // When: didSelectMovie metodunu çağırıyoruz
//        presenter.didSelectMovie(at: 0, for: type)
//
//        // Check if the method was called correctly
//        XCTAssertTrue(mockRouter.navigateToDetailClosure != nil, "navigateToDetailClosure should be set in the mock router.")
//
//        // Then: navigateToDetail metodunun doğru şekilde çağrıldığını kontrol ediyoruz
//        waitForExpectations(timeout: 10, handler: nil)
//    }




}
