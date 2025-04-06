//
//  CollectionCellInteractorTests.swift
//  SearchFlixTests
//
//  Created by Husnian Ali on 4.03.2025.
//

import XCTest
@testable import SearchFlix

final class CollectionCellInteractorTests: XCTestCase {
    private var interactor: CollectionCellInteractor!
    private var mockCacheManager: MockCacheManager!
    private var mockOutput: MockCollectionCellInteractorOutput!
    private let testImageURL = "https://m.media-amazon.com/images/M/MV5BYTZkODg1OGMtZmRiMC00ZjU0LWE3YzctOGE5ZDZjZTBlMTMwXkEyXkFqcGc@._V1_SX300.jpg"

    override func setUp() {
        super.setUp()
        mockCacheManager = MockCacheManager()
        mockOutput = MockCollectionCellInteractorOutput()
        interactor = CollectionCellInteractor(cacheManager: mockCacheManager)
        interactor.output = mockOutput
    }

    override func tearDown() {
        interactor = nil
        mockCacheManager = nil
        mockOutput = nil
        super.tearDown()
    }

    func testFetchImage_WhenURLIsNA_ShouldReturnNil() {
        // When
        interactor.fetchImage(from: "N/A")

        // Then
        XCTAssertTrue(mockOutput.didFetchImageCalled, "Output's didFetchImage(_:) method was not called.")
        XCTAssertNil(mockOutput.receivedImage, "Expected received image to be nil for 'N/A' URL.")
    }

    func testFetchImage_WhenImageExistsInCache_ShouldReturnCachedImage() {
        // Given
        let cachedImage = UIImage()
        mockCacheManager.cacheImage(cachedImage, for: testImageURL)

        // When
        interactor.fetchImage(from: testImageURL)

        // Then
        XCTAssertTrue(mockCacheManager.loadImageCalled, "Cache manager should be called but return cached image.")
        XCTAssertTrue(mockOutput.didFetchImageCalled, "Output's didFetchImage(_:) method was not called.")
        XCTAssertEqual(mockOutput.receivedImage, cachedImage, "Expected received image to match the cached image.")
    }

    func testFetchImage_WhenImageNotCached_ShouldReturnLoadedImage() {
        // Given
        let loadedImage = UIImage()
        mockCacheManager.imageToReturn = loadedImage

        // When
        interactor.fetchImage(from: testImageURL)

        // Then
        XCTAssertTrue(mockCacheManager.loadImageCalled, "Image should be loaded from network.")
        XCTAssertTrue(mockOutput.didFetchImageCalled, "Output's didFetchImage(_:) method was not called.")
        XCTAssertEqual(mockOutput.receivedImage, loadedImage, "Expected received image to match the loaded image.")
    }

    func test_processMovie_WhenOutputIsNil_ShouldNotCrash() {

        // Given
        interactor.output = nil

        // When
        interactor.fetchImage(from: testImageURL)

        // Then
        XCTAssertFalse(mockOutput.didFetchImageCalled, "didFetchImageCalled should not be called when output is nil!")
    }

    func test_getMovieDetails_WhenLoadImageFails_ShouldReturnNilImage() {
        // Given
        mockCacheManager.imageToReturn = nil

        // When
        interactor.fetchImage(from: testImageURL)

        // Then
        XCTAssertTrue(mockCacheManager.loadImageCalled, "loadImage function was not called!")
        XCTAssertTrue(mockOutput.didFetchImageCalled, "didFetchImageCalled was not called!")
        XCTAssertNil(mockOutput.receivedImage, "Image should be nil when loading fails!")
    }
}
