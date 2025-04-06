//
//  MockCollectionCellClasses.swift
//  SearchFlixTests
//
//  Created by Husnian Ali on 4.03.2025.
//

import UIKit
@testable import SearchFlix

// MARK: - MockCollectionViewCell
final class MockCollectionViewCell: CollectionViewCellProtocol {
    var displayImageCalled = false
    var receivedImage: UIImage?

    func displayImage(_ image: UIImage) {
        displayImageCalled = true
        receivedImage = image
    }
}

// MARK: - MockCollectionCellInteractor
final class MockCollectionCellInteractor: CollectionCellInteractorProtocol {
    var output: CollectionCellInteractorOutput?
    var fetchImageCalled = false
    var receivedURL: String?

    func fetchImage(from url: String) {
        fetchImageCalled = true
        receivedURL = url
    }
}

// MARK: - MockCollectionCellInteractorOutput
final class MockCollectionCellInteractorOutput: CollectionCellInteractorOutput {
    var didFetchImageCalled = false
    var receivedImage: UIImage?

    func didFetchImage(_ image: UIImage?) {
        didFetchImageCalled = true
        receivedImage = image
    }
}
