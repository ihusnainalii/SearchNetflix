//
//  CollectionCellInteractor.swift
//  SearchFlix
//
//  Created by Husnian Ali on 25.02.2025.
//

import Foundation

protocol CollectionCellInteractorProtocol {
    var output: CollectionCellInteractorOutput? { get set }
    func fetchImage(from url: String)
}

final class CollectionCellInteractor: CollectionCellInteractorProtocol {
    public weak var output: CollectionCellInteractorOutput?
    private let cacheManager: CacheManagerInterface
    
    init(cacheManager: CacheManagerInterface) {
        self.cacheManager = cacheManager
    }
    
    func fetchImage(from url: String) {
        if url == "N/A" {
            output?.didFetchImage(nil)
        } else {
            cacheManager.loadImage(from: url) { [weak self] image in
                guard let self else { return }
                self.output?.didFetchImage(image)
            }
        }
    }
}
