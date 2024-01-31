//
//  FavoritesVC.swift
//  MovieSearcher
//
//  Created by MacBook on 29.01.2024.
//

import UIKit

final class FavoritesVC: UIViewController {
    private let favoritesViewModel = FavoritesViewModel()
    //MARK: UI elements
    private let favoritesTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
        return tableView
    }()
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultConfigurations()
        setupUI()
        setupDelegates()
        setupBindings()
    }
    //MARK: Private methods
    private func defaultConfigurations() {
        view.backgroundColor = .white
        title = "Favorites"
    }
    
    private func setupBindings() {
        favoritesViewModel.favorites.bind { [weak self] _ in
            guard let self else { return }
            self.favoritesTableView.reloadData()
        }
    }
    
    private func setupUI() {
        view.addSubview(favoritesTableView)
        favoritesTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let movieData = favoritesViewModel.getMovie(index: indexPath.row) else { return }
        let genres = favoritesViewModel.gengres.value
        let detailVC = DetailMovieVC(with: movieData, genres: genres)
        navigationController?.pushViewController(detailVC, animated: true)
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
