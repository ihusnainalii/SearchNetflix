//
//  TableCellPresenterTests.swift
//  SearchFlixTests
//
//  Created by Husnian Ali on 4.03.2025.
//

import XCTest
@testable import SearchFlix

final class TableCellPresenterTests: XCTestCase {

    private var presenter: TableViewCellPresenter!
    private var mockView: MockTableViewCell!
    private var mockInteractor: MockTableViewCellInteractor!

    private var testMovie: MovieModel!

    override func setUp() {
        super.setUp()
        mockView = MockTableViewCell()
        mockInteractor = MockTableViewCellInteractor()
        presenter = TableViewCellPresenter(view: mockView, interactor: mockInteractor)

        testMovie = MovieModel(
            title: "Inception",
            year: "2010",
            id: "tt1375666",
            type: "movie",
            image: "https://example.com/inception.jpg"
        )
    }

    override func tearDown() {
        presenter = nil
        mockView = nil
        mockInteractor = nil
        testMovie = nil
        super.tearDown()
    }

    func testLoadMovie_ShouldCallInteractorProcessMovie() {
        // When
        presenter.loadMovie(movie: testMovie)

        // Then
        XCTAssertTrue(mockInteractor.processMovieCalled, "Interactor's processMovie(_:) method not called.")
        XCTAssertEqual(mockInteractor.receivedMovie?.title, testMovie.title, "Movie title mismatch.")
    }

    func testDidProcessMovie_ShouldCallViewUpdateUI() {
        // Given
        let title = testMovie.title
        let typeAndYear = "movie - 2010"
        let testImage = UIImage(named: "image")

        // When
        presenter.didProcessMovie(title: title, typeAndYear: typeAndYear, image: testImage)

        // Then
        XCTAssertTrue(mockView.updateUICalled, "View's updateUI method not called.")
        XCTAssertEqual(mockView.receivedTitle, title, "Movie title mismatch.")
        XCTAssertEqual(mockView.receivedTypeAndYear, typeAndYear, "Type and year mismatch.")
        XCTAssertEqual(mockView.receivedImage, testImage, "Image mismatch.")
    }

}
