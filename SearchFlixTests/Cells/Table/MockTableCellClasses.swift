//
//  MockTableCellClasses.swift
//  SearchFlixTests
//
//  Created by Husnian Ali on 4.03.2025.
//

import UIKit
@testable import SearchFlix

// MARK: - MockTableViewCell
final class MockTableViewCell: TableViewCellProtocol {
    var updateUICalled = false
    var receivedTitle: String?
    var receivedTypeAndYear: String?
    var receivedImage: UIImage?

    func updateUI(title: String, typeAndYear: String, image: UIImage?) {
        updateUICalled = true
        receivedTitle = title
        receivedTypeAndYear = typeAndYear
        receivedImage = image
    }
}


// MARK: - MockTableViewCellInteractor
final class MockTableViewCellInteractor: TableViewCellInteractorProtocol {
    var processMovieCalled = false
    var receivedMovie: MovieModel?

    func processMovie(_ movie: MovieModel) {
        processMovieCalled = true
        receivedMovie = movie
    }
}


// MARK: - TableViewCellInteractorOutputProtocol
final class MockTableViewCellInteractorOutput: TableViewCellInteractorOutputProtocol {
    var receivedTitle: String?
    var receivedTypeAndYear: String?
    var receivedImage: UIImage?
    var didProcessMovieCalled = false

    func didProcessMovie(title: String, typeAndYear: String, image: UIImage?) {
        didProcessMovieCalled = true
        receivedTitle = title
        receivedTypeAndYear = typeAndYear
        receivedImage = image
    }
}
