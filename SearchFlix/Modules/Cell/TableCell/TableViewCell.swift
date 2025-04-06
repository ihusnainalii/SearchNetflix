//
//  TableViewCell.swift
//  SearchFlix
//
//  Created by Husnian Ali on 17.02.2025.
//

import UIKit

protocol TableViewCellProtocol: AnyObject {
    func updateUI(title: String, typeAndYear: String, image: UIImage?)
}

final class TableViewCell: UITableViewCell {
    private lazy var containerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.darkGray.cgColor
        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var typeAndYearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    var presenter: TableViewCellPresenterProtocol!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        titleLabel.text = nil
        typeAndYearLabel.text = nil
    }
    
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(posterImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(typeAndYearLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            posterImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
            
            titleLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            
            typeAndYearLabel.bottomAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: -8),
            typeAndYearLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            typeAndYearLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func configure(with movie: MovieModel) {
        presenter?.loadMovie(movie: movie)
    }
}

// MARK: - TableViewCellProtocol
extension TableViewCell: TableViewCellProtocol {
    func updateUI(title: String, typeAndYear: String, image: UIImage?) {
        DispatchQueue.performOnMainThread {
            self.titleLabel.text = title
            self.typeAndYearLabel.text = typeAndYear
            self.posterImageView.image = image
        }
    }
}
