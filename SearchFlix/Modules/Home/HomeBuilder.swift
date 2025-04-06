//
//  HomeContractor.swift
//  SearchFlix
//
//  Created by Husnian Ali on 21.02.2025.
//

import UIKit

class HomeBuilder {
    static func build() -> UIViewController {
        let homeViewController = HomeViewController()
        let router = HomeRouter()
        let interactor = HomeInteractor()
        let presenter = HomePresenter(view: homeViewController, interactor: interactor, router: router)
        
        homeViewController.presenter = presenter
        interactor.output = presenter
        
        return homeViewController
    }
}
