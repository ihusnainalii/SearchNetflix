////
////  HomeInteractor.swift
////  SearchFlix
////
////  Created by Husnian Ali on 21.02.2025.
////
//
import Foundation

public enum FetchType {
    case search
    case collection
}

protocol HomeInteractorProtocol: AnyObject {
    var output: HomeInteractorOutputProtocol? { get set }
    func fetchMovies(type: FetchType, text: String?, page: Int)
}

protocol HomeInteractorOutputProtocol: AnyObject {
    func didFetchMovies(_ movies: [MovieModel], for type: FetchType)
    func didFailToFetchMovies(with error: Error, for type: FetchType)
}


final class HomeInteractor: HomeInteractorProtocol {
    private let networkManager: NetworkManagerProtocol
    public weak var output: HomeInteractorOutputProtocol?
    
    init(networkService: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkService
    }
    
    func fetchMovies(type: FetchType, text: String?, page: Int) {
        let queryText: String
        switch type {
        case .search:
            queryText = text ?? ""
        case .collection:
            queryText = "Comedy"
        }
        
        let endpoint = Endpoint.movieSearchTitle(movieSearchTitle: queryText, page: "\(page)")
        
        networkManager.makeRequest(endpoint: endpoint, type: SearchModel.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                self.output?.didFetchMovies(success.search, for: type)
            case .failure(let error):
                self.output?.didFailToFetchMovies(with: error, for: type)
            }
        }
    }
}
