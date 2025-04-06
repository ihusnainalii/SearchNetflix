//
//  HomePresenter.swift
//  SearchFlix
//
//  Created by Husnian Ali on 21.02.2025.
//

import Foundation

protocol HomePresenterProtocol: AnyObject {
    var searchMoviesCount: Int { get }
    var collectionMoviesCount: Int { get }

    func viewDidLoad()
    func searchMovies(searchText: String)
    func getMovie(at index: Int, for type: FetchType) -> MovieModel
    func didSelectMovie(at index: Int, for type: FetchType)
    func checkIfShouldFetchMoreMovies(at index: Int, for type: FetchType)
}

final class HomePresenter {
    private var isFetchingMovies = [FetchType.search: false, FetchType.collection: false]
    private var currentPages = [FetchType.search: 1, FetchType.collection: 1]
    private var searchText = "Star"

    // FLAGS
    // Flag'ler, her iki fetch işleminin tamamlanıp tamamlanmadığını takip edecek
    private var isSearchFetchComplete = false
    private var isCollectionFetchComplete = false
    private var isInitialFetch = true

    private weak var view: HomeViewProtocol?
    private let interactor: HomeInteractorProtocol
    private let router: HomeRouterProtocol
    public var movies: [FetchType: [MovieModel]] = [.search: [], .collection: []]

    init(view: HomeViewProtocol, interactor: HomeInteractorProtocol, router: HomeRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }


    // MARK: - Private
    private func fetchInitialData() {
        view?.setLoding(true, isFirstFetch: isInitialFetch)
        fetchMovies(type: .search)
        fetchMovies(type: .collection)
    }

    private func fetchMovies(type: FetchType) {
        isFetchingMovies[type] = true
        let page = currentPages[type] ?? 1

        interactor.fetchMovies(type: type, text: (type == .search ? searchText : nil), page: page)
    }

    private func resetMovies(for type: FetchType) {
        movies[type]?.removeAll()
        currentPages[type] = 1
        view?.setLoding(true, isFirstFetch: false)
    }


    private func hideLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.view?.setLoding(false, isFirstFetch: self.isInitialFetch)
        }
    }

    private func reloadView(for type: FetchType) {
        switch type {
        case .search:
            view?.reloadTable()
        case .collection:
            view?.reloadCollection()
        }
    }
}

// MARK: - HomePresenterProtocol
extension HomePresenter: HomePresenterProtocol {
    var searchMoviesCount: Int { movies[.search]?.count ?? 0 }
    var collectionMoviesCount: Int { movies[.collection]?.count ?? 0 }

    func viewDidLoad() {
        fetchInitialData()
    }

    func searchMovies(searchText: String) {
        self.searchText = searchText
        resetMovies(for: .search)
        self.view?.scrollToTop()
        fetchMovies(type: .search)
    }

    func getMovie(at index: Int, for type: FetchType) -> MovieModel {
        return movies[type]?[safe: index] ?? MovieModel(title: "", year: "", id: "", type: "", image: "")
    }

    func didSelectMovie(at index: Int, for type: FetchType) {
        guard let movie = movies[type]?[safe: index] else { return }
        guard let view = view else { return }
        router.navigateToDetail(from: view, movie: movie)
    }

    func checkIfShouldFetchMoreMovies(at index: Int, for type: FetchType) {
        guard let movieList = movies[type],
              index >= movieList.count - 3,
              isFetchingMovies[type] == false else { return }
        fetchMovies(type: type)
    }
}

// MARK: - HomeInteractorOutputProtocol
extension HomePresenter: HomeInteractorOutputProtocol {
    func didFetchMovies(_ movies: [MovieModel], for type: FetchType) {
        DispatchQueue.main.async {
            self.isFetchingMovies[type] = false

            if self.currentPages[type] == 1 {
                self.movies[type] = movies
                self.reloadView(for: type)
            } else {
                // Yeni verileri ekleyelim (flickering'i önlemek için)
                let startIndex = self.movies[type]?.count ?? 0
                self.movies[type]?.append(contentsOf: movies)

                let newIndexPaths = (startIndex..<self.movies[type]!.count).map { IndexPath(row: $0, section: 0) }
                if type == .search {
                    self.view?.updateTableView(with: newIndexPaths)
                } else {
                    self.view?.updateCollectionView(with: newIndexPaths)
                }
            }

            self.currentPages[type]? += 1

            if self.isInitialFetch {
                // İlk yükleme sırasında her iki işlem tamamlandığında loading'i kapat
                if !(self.isFetchingMovies[.search] ?? false) && !(self.isFetchingMovies[.collection] ?? false) {
                    self.isInitialFetch = false
                    self.hideLoading()
                }
            } else {
                // İlk yükleme tamamlandığında, sonrasındaki her fetch işlemi tamamlandığında loading'i kapat
                self.hideLoading()
            }
        }
    }

    func didFailToFetchMovies(with error: Error, for type: FetchType) {
        DispatchQueue.main.async {
            self.isFetchingMovies[type] = false
            self.view?.setLoding(false, isFirstFetch: self.isInitialFetch)
            self.view?.shorErrorAlert(error.localizedDescription)
        }
    }
}
