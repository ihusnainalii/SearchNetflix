//
//  CacheManagerTests.swift
//  SearchFlixTests
//
//  Created by Husnian Ali on 27.02.2025.
//

import XCTest
@testable import SearchFlix

final class CacheManagerTests: XCTestCase {
    // MARK: - Properties
    var mockCacheManager: MockCacheManager!
    let testImageURL = "https://m.media-amazon.com/images/M/MV5BOGUwMDk0Y2MtNjBlNi00NmRiLTk2MWYtMGMyMDlhYmI4ZDBjXkEyXkFqcGc@._V1_SX300.jpg"
    var testImage: UIImage?

    // MARK: - Setup & Teardown
    override func setUp() {
        super.setUp()
        mockCacheManager = MockCacheManager()

        testImage = UIImage(named: "image") // "image" asset ismi
    }

    override func tearDown() {
        mockCacheManager = nil
        testImage = nil
        super.tearDown()
    }

    func testGetImageReturnsCachedImage() {
        // Given
        guard let image = testImage else {
            XCTFail("Image could not be loaded from assets!")
            return
        }

        // When
        mockCacheManager.cacheImage(image, for: testImageURL)

        // Then
        let cachedImage = mockCacheManager.getImage(for: testImageURL)
        XCTAssertNotNil(cachedImage, "Image was not cached correctly!")
        XCTAssertEqual(cachedImage, image, "The cached image is not the same as the original image!")
    }

    func testGetImageReturnsNilForNonCachedImage() {
        // Given
        let nonCachedURL = " https://m.media-amazon.com/images/M/MV5BMTkxNGFlNDktZmJkNC00MDdhLTg0MTEtZjZiYWI3MGE5NWIwXkEyXkFqcGc@._V1_SX300.jp"

        // When
        let retrievedImage = mockCacheManager.getImage(for: nonCachedURL)

        // Then
        XCTAssertNil(retrievedImage, "getImage should return nil for an image not in cache!")
    }


    func testLoadImageReturnsCachedImageWhenAvailable() {
        // Given
        guard let image = testImage else {
            XCTFail("Image could not be loaded from assets!")
            return
        }
        mockCacheManager.cacheImage(image, for: testImageURL)

        let expectation = XCTestExpectation(description: "Image should be returned from cache")

        // When
        var returnedImage: UIImage?
        mockCacheManager.loadImage(from: testImageURL) { image in
            returnedImage = image
            expectation.fulfill()
        }

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(mockCacheManager.loadImageCalled, "loadImage was not called!")
        XCTAssertEqual(returnedImage, image, "The cached image was not returned!")
    }

    func testLoadImageReturnsNilWhenImageNotInCache() {
        // Given

        let expectation = XCTestExpectation(description: "Nil image should be returned when not in cache")

        // When
        var returnedImage: UIImage?
        mockCacheManager.loadImage(from: testImageURL) { image in
            returnedImage = image
            expectation.fulfill()
        }

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(mockCacheManager.loadImageCalled, "loadImage was not called!")
        XCTAssertNil(returnedImage, "Image should be nil when not in cache!")
    }


    func testLoadImageReturnsImageFromURL() {
        // Given
        guard let expectedImage = testImage else {
            XCTFail("Image could not be loaded from assets!")
            return
        }
        mockCacheManager.imageToReturn = expectedImage

        let expectation = XCTestExpectation(description: "Image should be loaded from URL")

        // When
        var returnedImage: UIImage?
        mockCacheManager.loadImage(from: testImageURL) { image in
            returnedImage = image
            expectation.fulfill()
        }

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(mockCacheManager.loadImageCalled, "loadImage was not called!")
        XCTAssertEqual(returnedImage, expectedImage, "The image returned from the URL is not correct!")
    }

    func testLoadImageReturnsNilForInvalidURL() {
        // Given
        let invalidURL = "invalid-url"

        let expectation = XCTestExpectation(description: "Load image should return nil for invalid URL")

        // When
        var returnedImage: UIImage?
        mockCacheManager.loadImage(from: invalidURL) { image in
            returnedImage = image
            expectation.fulfill()
        }

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(mockCacheManager.loadImageCalled, "loadImage was not called!")
        XCTAssertNil(returnedImage, "Image should be nil for an invalid URL!")
    }

}
