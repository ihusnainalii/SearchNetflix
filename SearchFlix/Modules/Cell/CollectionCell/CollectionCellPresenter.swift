//
//  CollectionCellPresenter.swift
//  SearchFlix
//
//  Created by Husnian Ali on 25.02.2025.
//

import UIKit

protocol CollectionCellPresenterProtocol: AnyObject {
    func loadImage(for url: String)
}

protocol CollectionCellInteractorOutput: AnyObject {
    func didFetchImage(_ image: UIImage?)
}

final class CollectionCellPresenter: CollectionCellPresenterProtocol {
    public weak var view: (CollectionViewCellProtocol)?
    private let interactor: CollectionCellInteractorProtocol
    
    init(view: CollectionViewCellProtocol, interactor: CollectionCellInteractorProtocol) {
        self.view = view
        self.interactor = interactor
    }
    
    func loadImage(for url: String) {
        interactor.fetchImage(from: url)
    }
}

// MARK: - CollectionCellInteractorOutput
extension CollectionCellPresenter: CollectionCellInteractorOutput {
    func didFetchImage(_ image: UIImage?) {
        view?.displayImage(UIImage.fromImage(image))
    }
}
