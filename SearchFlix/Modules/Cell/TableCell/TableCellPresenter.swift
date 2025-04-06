//
//  TableCellPresenter.swift
//  SearchFlix
//
//  Created by Husnian Ali on 25.02.2025.
//

import UIKit

protocol TableViewCellPresenterProtocol {
    func loadMovie(movie: MovieModel)
}

protocol TableViewCellInteractorOutputProtocol: AnyObject {
    func didProcessMovie(title: String, typeAndYear: String, image: UIImage?)
}

final class TableViewCellPresenter {
    weak var view: TableViewCellProtocol?
    var interactor: TableViewCellInteractorProtocol
    
    init(view: TableViewCellProtocol, interactor: TableViewCellInteractorProtocol) {
        self.view = view
        self.interactor = interactor
    }
}

// MARK: - TableViewCellPresenterProtocol
extension TableViewCellPresenter: TableViewCellPresenterProtocol {
    func loadMovie(movie: MovieModel) {
        interactor.processMovie(movie)
    }
}

// MARK: - TableViewCellInteractorOutputProtocol
extension TableViewCellPresenter: TableViewCellInteractorOutputProtocol {
    func didProcessMovie(title: String, typeAndYear: String, image: UIImage?) {
        view?.updateUI(title: title, typeAndYear: typeAndYear, image: UIImage.fromImage(image))
    }
}
