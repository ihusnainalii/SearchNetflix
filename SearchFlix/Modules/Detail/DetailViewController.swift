//
//  DetailViewController.swift
//  SearchFlix
//
//  Created by Husnian Ali on 17.02.2025.
//

import UIKit

protocol DetailViewProtocol: AnyObject {
    func displayMovieDetails(_ movie: MovieModel, image: UIImage)
}

final class DetailViewController: UIViewController {
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, typeLabel, yearLabel])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var presenter: DetailPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }
    
    private func setupUI() {
        navigationController?.navigationBar.tintColor = .gray
        view.backgroundColor = .white
        view.addSubview(posterImageView)
        view.addSubview(infoStackView)
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            posterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            posterImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            posterImageView.heightAnchor.constraint(equalToConstant: 250),
            
            infoStackView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 20),
            infoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            infoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}

// MARK: - DetailViewProtocol
extension DetailViewController: DetailViewProtocol {
    func displayMovieDetails(_ movie: MovieModel, image: UIImage) {
        DispatchQueue.performOnMainThread {
            self.titleLabel.text = movie.title
            self.typeLabel.text = movie.type.capitalized
            self.yearLabel.text = movie.year
            self.posterImageView.image = image
        }
    }
}
