//
//  MockHomeClasses.swift
//  SearchFlixTests
//
//  Created by Husnian Ali on 4.03.2025.
//

import UIKit
@testable import SearchFlix


// MARK: - MockHomeViewProtocol
class MockHomeView: HomeViewProtocol {
    var reloadTableCalled = false
    var reloadCollectionCalled = false
    var showErrorAlertMessage: String?
    var setLodingCalled = false
    var scrollToTopCalled = false
    var updateTableViewCalled = false
    var updateCollectionViewCalled = false

    var isLoading: Bool = false
    var isFirstFetch: Bool = false

    func reloadTable() {
        reloadTableCalled = true
    }

    func reloadCollection() {
        reloadCollectionCalled = true
    }

    func shorErrorAlert(_ message: String) {
        showErrorAlertMessage = message
    }

    func setLoding(_ isLoading: Bool, isFirstFetch: Bool) {
        setLodingCalled = true
        self.isLoading = isLoading
        self.isFirstFetch = isFirstFetch
    }

    func scrollToTop() {
        scrollToTopCalled = true
    }

    func updateTableView(with indexPaths: [IndexPath]) {
        updateTableViewCalled = true
    }

    func updateCollectionView(with indexPaths: [IndexPath]) {
        updateCollectionViewCalled = true
    }
}

// MARK: - MockHomeInteractorProtocol
class MockHomeInteractor: HomeInteractorProtocol {
    weak var output: HomeInteractorOutputProtocol?
    var fetchMoviesCalled = false
    var fetchMoviesText: String?
    var fetchMoviesPage: Int?
    var moviesToReturn: [MovieModel] = []
    var fetchMoviesError: Error?
    var didFetchMoviesCalled = false
    var didFailToFetchMoviesCalled = false

    func fetchMovies(type: FetchType, text: String?, page: Int) {
        fetchMoviesCalled = true
        fetchMoviesText = text
        fetchMoviesPage = page

        if let error = fetchMoviesError {
            // Simulate error response
            didFailToFetchMoviesCalled = true
            output?.didFailToFetchMovies(with: error, for: type)
        } else {
            // Simulate successful fetch
            didFetchMoviesCalled = true
            output?.didFetchMovies(moviesToReturn, for: type)
        }
    }
}


// MARK: - MockHomeRouterProtocol
class MockHomeRouter: HomeRouterProtocol {
    var navigateToDetailClosure: ((UIViewController, MovieModel) -> Void)?

    func navigateToDetail(from view: any HomeViewProtocol, movie: MovieModel) {
        print("navigateToDetail called")  // Test için kontrol ekliyoruz
        guard let viewController = view as? UIViewController else {
            print("Error: view cannot be cast to UIViewController")
            return
        }
        navigateToDetailClosure?(viewController, movie)
    }
}



// MARK: - MockHomeInteractorOutput
final class MockHomeInteractorOutput: HomeInteractorOutputProtocol {
    var fetchedMovies: [MovieModel]? = nil
    var fetchError: Error?
    var fetchType: FetchType?
    var isDidFetchMoviesCalled = false
    var isDidFailToFetchMoviesCalled = false

    func didFetchMovies(_ movies: [MovieModel], for type: FetchType) {
        fetchedMovies = movies
        fetchType = type
        isDidFetchMoviesCalled = true
    }

    func didFailToFetchMovies(with error: Error, for type: FetchType) {
        fetchError = error
        fetchType = type
        isDidFailToFetchMoviesCalled = true
    }
}
