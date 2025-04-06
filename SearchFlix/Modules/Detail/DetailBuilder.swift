//
//  DetailBuilder.swift
//  SearchFlix
//
//  Created by Husnian Ali on 24.02.2025.
//

import UIKit

class DetailBuilder {
    static func build(with movie: MovieModel) -> UIViewController {
        let detailViewController = DetailViewController()
        let interactor = DetailInteractor(cacheManager: CacheManager(), movie: movie)
        let presenter = DetailPresenter(view: detailViewController, interactor: interactor)
        
        detailViewController.presenter = presenter
        interactor.output = presenter
        
        return detailViewController
    }
}
