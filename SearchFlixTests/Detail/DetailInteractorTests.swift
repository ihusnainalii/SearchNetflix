//
//  DetailInteractorTests.swift
//  SearchFlixTests
//
//  Created by Husnian Ali on 1.03.2025.
//

import XCTest
@testable import SearchFlix

final class DetailInteractorTests: XCTestCase {
    private var interactor: DetailInteractor!
    private var mockCacheManager: MockCacheManager!
    private var mockOutput: MockDetailInteractorOutput!
    
    private var movieWithNoImage: MovieModel!
    private var movieWithImage: MovieModel!
    private var cachedImage: UIImage!
    private var loadedImage: UIImage!
    
    override func setUp() {
        super.setUp()
        mockCacheManager = MockCacheManager()
        mockOutput = MockDetailInteractorOutput()
        
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
    
    private func setupInteractor(with movie: MovieModel) {
        interactor = DetailInteractor(cacheManager: mockCacheManager, movie: movie)
        interactor.output = mockOutput
    }
    
    func test_getMovieDetails_WhenImageIsNA_ShouldReturnNilImage() {
        // Given
        setupInteractor(with: movieWithNoImage)
        
        // When
        interactor.getMovieDetails()
        
        // Then
        XCTAssertTrue(mockOutput.didFetchMovieDetailsCalled, "didFetchMovieDetails was not called!")
        XCTAssertEqual(mockOutput.receivedMovie?.title, movieWithNoImage.title)
        XCTAssertNil(mockOutput.receivedImage)
    }
    
    func test_getMovieDetails_WhenImageExistsInCache_ShouldReturnCachedImage() {
        // Given
        mockCacheManager.cacheImage(cachedImage, for: movieWithImage.image)
        setupInteractor(with: movieWithImage)
        
        // When
        interactor.getMovieDetails()
        
        // Then
        XCTAssertTrue(mockCacheManager.loadImageCalled, "loadImage function was not called!")
        XCTAssertTrue(mockOutput.didFetchMovieDetailsCalled, "didFetchMovieDetails was not called!")
        XCTAssertEqual(mockOutput.receivedMovie?.title, movieWithImage.title)
        XCTAssertEqual(mockOutput.receivedImage, cachedImage)
    }
    
    func test_getMovieDetails_WhenImageNotInCacheButLoads_ShouldReturnLoadedImage() {
        // Given
        mockCacheManager.imageToReturn = loadedImage
        setupInteractor(with: movieWithImage)
        
        // When
        interactor.getMovieDetails()
        
        // Then
        XCTAssertTrue(mockCacheManager.loadImageCalled, "loadImage function was not called!")
        XCTAssertTrue(mockOutput.didFetchMovieDetailsCalled, "didFetchMovieDetails was not called!")
        XCTAssertEqual(mockOutput.receivedMovie?.title, movieWithImage.title)
        XCTAssertEqual(mockOutput.receivedImage, loadedImage)
    }
    
    func test_getMovieDetails_WhenOutputIsNil_ShouldNotCrash() {
        // Given
        setupInteractor(with: movieWithImage)
        interactor.output = nil
        
        // When
        interactor.getMovieDetails()
        
        // Then
        XCTAssertFalse(mockOutput.didFetchMovieDetailsCalled, "didFetchMovieDetails should not be called when output is nil!")
    }
    
    func test_getMovieDetails_WhenLoadImageFails_ShouldReturnNilImage() {
        // Given
        mockCacheManager.imageToReturn = nil
        setupInteractor(with: movieWithImage)
        
        // When
        interactor.getMovieDetails()
        
        // Then
        XCTAssertTrue(mockCacheManager.loadImageCalled, "loadImage function was not called!")
        XCTAssertTrue(mockOutput.didFetchMovieDetailsCalled, "didFetchMovieDetails was not called!")
        XCTAssertNil(mockOutput.receivedImage, "Image should be nil when loading fails!")
    }
}
