//
//  CollectionCellPresenterTests.swift
//  SearchFlixTests
//
//  Created by Husnian Ali on 4.03.2025.
//

import XCTest
@testable import SearchFlix

final class CollectionCellPresenterTests: XCTestCase {
    private var presenter: CollectionCellPresenter!
    private var mockView: MockCollectionViewCell!
    private var mockInteractor: MockCollectionCellInteractor!


    override func setUp() {
        super.setUp()
        mockView = MockCollectionViewCell()
        mockInteractor = MockCollectionCellInteractor()
        presenter = CollectionCellPresenter(view: mockView, interactor: mockInteractor)
    }

    override func tearDown() {
        presenter = nil
        mockView = nil
        mockInteractor = nil
        super.tearDown()
    }

    func testLoadImage_CallsFetchImageOnInteractor() {
        // Given
        let testURL = "https://example.com/inception.jpg"

        // When
        presenter.loadImage(for: testURL)

        // Then
        XCTAssertTrue(mockInteractor.fetchImageCalled, "fetchImage(from:) should be called on interactor")
        XCTAssertEqual(mockInteractor.receivedURL, testURL, "Interactor should receive the correct URL")
    }

    func testDidFetchImage_CallsDisplayImageOnView() {
        // Given
        let testImage = UIImage(named: "image")

        // When
        presenter.didFetchImage(testImage)

        // Then
        XCTAssertTrue(mockView.displayImageCalled, "displayImage(_:) should be called on view")
        XCTAssertEqual(mockView.receivedImage, testImage, "View should receive the correct image")
    }

}
