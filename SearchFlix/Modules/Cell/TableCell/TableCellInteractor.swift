//
//  TableCellInteractor.swift
//  SearchFlix
//
//  Created by Husnian Ali on 25.02.2025.
//

import Foundation

protocol TableViewCellInteractorProtocol {
    func processMovie(_ movie: MovieModel)
}

final class TableViewCellInteractor: TableViewCellInteractorProtocol {
    public weak var output: TableViewCellInteractorOutputProtocol?
    private let cacheManager: CacheManagerInterface
    
    init(cacheManager: CacheManagerInterface) {
        self.cacheManager = cacheManager
    }
    
    func processMovie(_ movie: MovieModel) {
        let title = movie.title
        let typeAndYear = "\(movie.type) - \(movie.year)"
        
        if movie.image == "N/A" {
            output?.didProcessMovie(title: title, typeAndYear: typeAndYear, image: nil)
        } else {
            cacheManager.loadImage(from: movie.image) { [weak self] image in
                guard let self else { return }
                self.output?.didProcessMovie(title: title, typeAndYear: typeAndYear, image: image)
            }
        }
    }
}
