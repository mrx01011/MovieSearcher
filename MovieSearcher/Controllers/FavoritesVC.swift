//
//  FavoritesVC.swift
//  MovieSearcher
//
//  Created by MacBook on 29.01.2024.
//

import UIKit

final class FavoritesVC: UIViewController {
    private let favoritesViewModel = FavoritesViewModel()
    private var favorites = [Movie]()
    //MARK: UI elements
    private let favoritesTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 100
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultConfigurations()
        setupUI()
        setupDelegates()
        refreshData()
    }
    //MARK: Private methods
    private func defaultConfigurations() {
        view.backgroundColor = .white
        title = "Favorites"
    }
    
    private func refreshData() {
        self.favoritesViewModel.isMovieFavorited = { [weak self] (_, success) in
            guard let self else { return }
            if success {
                self.favoritesTableView.reloadData()
            }
        }
    }
    
    private func setupUI() {
        view.addSubview(favoritesTableView)
        
        favoritesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        favoritesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        favoritesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        favoritesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
    }
    
    private func setupDelegates() {
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
    }
}
//MARK: - UITableViewDelegate, UITableViewDataSource
extension FavoritesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesViewModel.getNumberOrRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier) as? MovieTableViewCell,
              let movieData = favoritesViewModel.getMovie(index: indexPath.row) else { return UITableViewCell() }
        cell.configureCell(with: movieData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            tableView.beginUpdates()
            favoritesViewModel.deleteMovie(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        default: break
        }
    }
}
//MARK: - Constants
extension FavoritesVC {
    enum Constants {
        static let cellIdentifier = "FavoriteCell"
    }
}
