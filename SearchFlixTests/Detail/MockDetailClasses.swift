//
//  MockDetailClasses.swift
//  SearchFlixTests
//
//  Created by Husnian Ali on 1.03.2025.
//

import UIKit
@testable import SearchFlix

// MARK: - MockDetailView
final class MockDetailView: DetailViewProtocol {
    var displayMovieDetailsCalled = false
    var displayedMovie: MovieModel?
    var displayedImage: UIImage?

    func displayMovieDetails(_ movie: MovieModel, image: UIImage) {
        displayMovieDetailsCalled = true
        displayedMovie = movie
        displayedImage = image
    }
}

// MARK: - MockDetailInteractor
final class MockDetailInteractor: DetailInteractorProtocol {
    var output: DetailInteractorOutput?
    var getMovieDetailsCalled = false

    func getMovieDetails() {
        getMovieDetailsCalled = true
    }
}

// MARK: - MockDetailInteractorOutput

//Çünkü DetailInteractor içinde output?.didFetchMovieDetails(movie, image: nil) çağrılıyor ve biz bunun çağrılıp çağrılmadığını test etmek istiyoruz.
//Eğer DetailInteractorOutput için bir mock nesne oluşturmazsak, DetailInteractor'ın bu metodu gerçekten çağırıp çağırmadığını bilemeyiz.

final class MockDetailInteractorOutput: DetailInteractorOutput {
    var receivedMovie: MovieModel?
    var receivedImage: UIImage?
    var didFetchMovieDetailsCalled = false

    func didFetchMovieDetails(_ movie: MovieModel, image: UIImage?) {
        didFetchMovieDetailsCalled = true
        receivedMovie = movie
        receivedImage = image
    }
}
