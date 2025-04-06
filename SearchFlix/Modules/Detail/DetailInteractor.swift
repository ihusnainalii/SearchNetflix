//
//  DetailInteractor.swift
//  SearchFlix
//
//  Created by Husnian Ali on 24.02.2025.
//

import Foundation

protocol DetailInteractorProtocol: AnyObject{
    var output: DetailInteractorOutput? { get set }
    func getMovieDetails()
}

final class DetailInteractor {
    public weak var output: DetailInteractorOutput?
    private let cacheManager: CacheManagerInterface
    private let movie: MovieModel
    
    init(cacheManager: CacheManagerInterface, movie: MovieModel) {
        self.cacheManager = cacheManager
        self.movie = movie
    }
}

// MARK: - DetailInteractorProtocol
extension DetailInteractor: DetailInteractorProtocol {
    func getMovieDetails() {
        if movie.image == "N/A" {
            output?.didFetchMovieDetails(movie, image: nil)
        } else {
            cacheManager.loadImage(from: movie.image) { [weak self] image in
                guard let self else { return }
                self.output?.didFetchMovieDetails(self.movie, image: image)
            }
        }
    }
}
