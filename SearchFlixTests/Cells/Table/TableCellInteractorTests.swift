//
//  TableCellInteractorTests.swift
//  SearchFlixTests
//
//  Created by Husnian Ali on 4.03.2025.
//

import XCTest
@testable import SearchFlix

final class TableCellInteractorTests: XCTestCase {
    private var interactor: TableViewCellInteractor!
    private var mockCacheManager: MockCacheManager!
    private var mockOutput: MockTableViewCellInteractorOutput!

    private var movieWithNoImage: MovieModel!
    private var movieWithImage: MovieModel!
    private var cachedImage: UIImage!
    private var loadedImage: UIImage!

    override func setUp() {
        super.setUp()
        mockCacheManager = MockCacheManager()
        mockOutput = MockTableViewCellInteractorOutput()
        interactor = TableViewCellInteractor(cacheManager: mockCacheManager)
        interactor.output = mockOutput

        movieWithNoImage = MovieModel(
            title: "Arg_gubbe.mov",
            year: "2024",
            id: "tt33379110",
            type: "movie",
            image: "N/A")

        movieWithImage = MovieModel(
            title: "Min and Bill",
            year: "1930",
            id: "tt0021148",
            type: "movie",
            image: "https://m.media-amazon.com/images/M/MV5BYTZkODg1OGMtZmRiMC00ZjU0LWE3YzctOGE5ZDZjZTBlMTMwXkEyXkFqcGc@._V1_SX300.jpg")

        cachedImage = UIImage()
        loadedImage = UIImage()
    }

    override func tearDown() {
        interactor = nil
        mockCacheManager = nil
        mockOutput = nil
        movieWithNoImage = nil
        movieWithImage = nil
        cachedImage = nil
        loadedImage = nil
        super.tearDown()
    }


    func testProcessMovie_WhenImageIsNA_ShouldReturnNilImage() {
        // When
        interactor.processMovie(movieWithNoImage)

        // Then
        XCTAssertTrue(mockOutput.didProcessMovieCalled, "didProcessMovieCalled was not called!")
        XCTAssertEqual(mockOutput.receivedTitle, movieWithNoImage.title)
        XCTAssertEqual(mockOutput.receivedTypeAndYear, "movie - 2024")
        XCTAssertNil(mockOutput.receivedImage)
        XCTAssertFalse(mockCacheManager.loadImageCalled, "Cache manager should NOT be called for 'N/A' images.")
    }

    func testProcessMovie_WhenImageExistsInCache_ShouldReturnCachedImage() {
        // Given
        mockCacheManager.cacheImage(cachedImage, for: movieWithImage.image)

        // When
        interactor.processMovie(movieWithImage)

        // Then
        XCTAssertTrue(mockCacheManager.loadImageCalled, "Cache manager should be called but return cached image.")
        XCTAssertTrue(mockOutput.didProcessMovieCalled, "didProcessMovieCalled was not called!")
        XCTAssertEqual(mockOutput.receivedTitle, movieWithImage.title)
        XCTAssertEqual(mockOutput.receivedTypeAndYear, "movie - 1930")
        XCTAssertEqual(mockOutput.receivedImage, cachedImage)
    }

    func test_getMovieDetails_WhenImageNotInCacheButLoads_ShouldReturnLoadedImage() {
        // Given
        mockCacheManager.imageToReturn = loadedImage

        // When
        interactor.processMovie(movieWithImage)

        // Then
        XCTAssertTrue(mockCacheManager.loadImageCalled, "Image should be loaded from network.")
        XCTAssertTrue(mockOutput.didProcessMovieCalled, "didProcessMovieCalled was not called!")
        XCTAssertEqual(mockOutput.receivedTitle, movieWithImage.title)
        XCTAssertEqual(mockOutput.receivedTypeAndYear, "movie - 1930")
        XCTAssertEqual(mockOutput.receivedImage, loadedImage)
    }


    func test_processMovie_WhenOutputIsNil_ShouldNotCrash() {
        // Given
        interactor.output = nil

        // When
        interactor.processMovie(movieWithImage)

        // Then
        XCTAssertFalse(mockOutput.didProcessMovieCalled, "didProcessMovieCalled should not be called when output is nil!")
    }

    func test_getMovieDetails_WhenLoadImageFails_ShouldReturnNilImage() {
        // Given
        mockCacheManager.imageToReturn = nil

        // When
        interactor.processMovie(movieWithImage)

        // Then
        XCTAssertTrue(mockCacheManager.loadImageCalled, "loadImage function was not called!")
        XCTAssertTrue(mockOutput.didProcessMovieCalled, "didProcessMovieCalled was not called!")
        XCTAssertNil(mockOutput.receivedImage, "Image should be nil when loading fails!")
    }



}
