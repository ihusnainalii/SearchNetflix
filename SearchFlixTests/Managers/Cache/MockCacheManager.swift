//
//  MockCacheManager.swift
//  SearchFlixTests
//
//  Created by Husnian Ali on 27.02.2025.
//

import UIKit
@testable import SearchFlix

final class MockCacheManager: CacheManagerInterface {
    // MARK: - Test Flags
    var loadImageCalled = false

    // MARK: - Properties
    var imageToReturn: UIImage?
    private var cachedImages = [String: UIImage]()

    // MARK: - Methods
    func getImage(for url: String) -> UIImage? {
        return cachedImages[url]
    }

    func cacheImage(_ image: UIImage, for url: String) {
        cachedImages[url] = image
    }

    func loadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        loadImageCalled = true
        if let cachedImage = getImage(for: url) {
            completion(cachedImage)
        } else {
            completion(imageToReturn)
        }
    }
}
