//
//  DetailPresenterTests.swift
//  SearchFlixTests
//
//  Created by Husnian Ali on 3.03.2025.
//
import XCTest
@testable import SearchFlix

final class DetailPresenterTests: XCTestCase {
    private var presenter: DetailPresenter!
    private var mockInteractor: MockDetailInteractor!
    private var mockView: MockDetailView!

    override func setUp() {
        super.setUp()
        mockInteractor = MockDetailInteractor()
        mockView = MockDetailView()
        presenter = DetailPresenter(view: mockView, interactor: mockInteractor)
        mockInteractor.output = presenter
    }

    override func tearDown() {
        presenter = nil
        mockInteractor = nil
        mockView = nil
        super.tearDown()
    }

    func test_viewDidLoad_CallsGetMovieDetails() {
        // When
        presenter.viewDidLoad()

        // Then
        XCTAssertTrue(mockInteractor.getMovieDetailsCalled, "Interactor's getMovieDetails method should be called when viewDidLoad is triggered.")
    }

    func test_didFetchMovieDetails_CallsDisplayMovieDetails() {
        // Given
        let testMovie = MovieModel(
            title: "Star Wars: Episode IV - A New Hope",
            year: "1977",
            id: "tt0076759",
            type: "movie",
            image: "https://m.media-amazon.com/images/M/MV5BOGUwMDk0Y2MtNjBlNi00NmRiLTk2MWYtMGMyMDlhYmI4ZDBjXkEyXkFqcGc@._V1_SX300.jpg"
        )
        let testImage = UIImage(named: "image")
        
        // When
        presenter.didFetchMovieDetails(testMovie, image: testImage)

        // Then
        XCTAssertTrue(mockView.displayMovieDetailsCalled, "View's displayMovieDetails method should be called when didFetchMovieDetails is triggered.")
        XCTAssertEqual(mockView.displayedMovie?.title, testMovie.title, "Displayed movie title does not match the expected value.")
        XCTAssertEqual(mockView.displayedImage, testImage, "Displayed image does not match the expected value.")
    }
}
