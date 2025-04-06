//
//  HomeRouter.swift
//  SearchFlix
//
//  Created by Husnian Ali on 21.02.2025.
//

import UIKit

protocol HomeRouterProtocol: AnyObject {
    func navigateToDetail(from view: HomeViewProtocol, movie: MovieModel)
}

final class HomeRouter: HomeRouterProtocol {
    func navigateToDetail(from view: HomeViewProtocol, movie: MovieModel) {
        guard let viewController = view as? UIViewController else { return }
        let detailVC = DetailBuilder.build(with: movie)
        viewController.navigationController?.pushViewController(detailVC, animated: true)
    }
}
