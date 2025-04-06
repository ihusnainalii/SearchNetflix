//
//  DetailPresenter.swift
//  SearchFlix
//
//  Created by Husnian Ali on 24.02.2025.
//

import UIKit

protocol DetailPresenterProtocol: AnyObject {
    func viewDidLoad()
}

protocol DetailInteractorOutput: AnyObject {
    func didFetchMovieDetails(_ movie: MovieModel, image: UIImage?)
}

final class DetailPresenter {
    public weak var view: DetailViewProtocol?
    private let interactor: DetailInteractorProtocol
    
    init(view: DetailViewProtocol, interactor: DetailInteractorProtocol) {
        self.view = view
        self.interactor = interactor
    }
}

// MARK: - DetailPresenterProtocol
extension DetailPresenter: DetailPresenterProtocol {
    func viewDidLoad() {
        interactor.getMovieDetails()
    }
}

// MARK: - DetailInteractorOutput
extension DetailPresenter: DetailInteractorOutput {
    func didFetchMovieDetails(_ movie: MovieModel, image: UIImage?) {
        view?.displayMovieDetails(movie, image: UIImage.fromImage(image))
    }
}
