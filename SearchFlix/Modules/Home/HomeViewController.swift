//
//  HomeViewController.swift
//  SearchFlix
//
//  Created by Husnian Ali on 17.02.2025.
//

import UIKit

protocol HomeViewProtocol: AnyObject {
    func reloadTable()
    func reloadCollection()
    func shorErrorAlert(_ message: String)
    func setLoding(_ isLoading: Bool, isFirstFetch: Bool)
    func scrollToTop()
    func updateTableView(with indexPaths: [IndexPath])
    func updateCollectionView(with indexPaths: [IndexPath])
}

final class HomeViewController: UIViewController {
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Movie"
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        return tableView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.backgroundColor = .lightGray
        return collectionView
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .black
        indicator.isHidden = true
        return indicator
    }()
    
    var presenter: HomePresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        presenter.viewDidLoad()
    }
    
    private func setupNavigationBar() {
        title = "SearchFlix"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(collectionView)
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 60),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            collectionView.heightAnchor.constraint(equalToConstant: 230),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 0)
    }
}

// MARK: - HomeViewProtocol
extension HomeViewController: HomeViewProtocol {
    func reloadTable() {
        tableView.reloadData()
    }
    
    func reloadCollection() {
        collectionView.reloadData()
    }
    
    func shorErrorAlert(_ message: String) {
        showAlert(message: message)
    }
    
    func setLoding(_ isLoading: Bool, isFirstFetch: Bool) {
        loadingIndicator.isHidden = !isLoading
        isLoading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
        
        tableView.isHidden = isLoading
        collectionView.isHidden = isFirstFetch ? isLoading : false
    }
    
    func scrollToTop() {
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }

    func updateTableView(with indexPaths: [IndexPath]) {
        tableView.insertRows(at: indexPaths, with: .none)
    }

    func updateCollectionView(with indexPaths: [IndexPath]) {
        collectionView.insertItems(at: indexPaths)
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.searchMoviesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell else {
            fatalError("Unable to dequeue TableViewCell")
        }
        if cell.presenter ==  nil {
            TableCellBuilder.build(cell: cell)
        }
        cell.configure(with: presenter.getMovie(at: indexPath.row, for: .search))
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectMovie(at: indexPath.row, for: .search)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.presenter.checkIfShouldFetchMoreMovies(at: indexPath.row, for: .search)
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.collectionMoviesCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else {
            fatalError("Unable to dequeue CollectionViewCell")
        }
        if cell.presenter == nil {
            CollectionCellBuilder.build(cell: cell)
        }
        cell.configure(with: presenter.getMovie(at: indexPath.row, for: .collection).image)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectMovie(at: indexPath.row, for: .collection)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 240, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        presenter.checkIfShouldFetchMoreMovies(at: indexPath.item, for: .collection)
    }
}

// MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else { return }
        presenter.searchMovies(searchText: text)
    }
}
