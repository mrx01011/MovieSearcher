//
//  ListVC.swift
//  MovieSearcher
//
//  Created by MacBook on 29.01.2024.
//

import UIKit

final class ListVC: UIViewController {
    private var movieListViewModel = MovieListViewModel()
    //MARK: UI elements
    @IBOutlet private var moviesTableView: UITableView!
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        self.movieListViewModel.isMoviesLoaded = { [weak self] (_, success) in
            guard let self else { return }
            if success {
                self.moviesTableView.reloadData()
            } 
        }
    }
    //MARK: Private methods
    private func setupDelegates() {
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
    }
}
//MARK: - UITableViewDelegate, UITableViewDataSource
extension ListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieListViewModel.numberOrRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier) as? MovieTableViewCell,
              let movieData = movieListViewModel.getMovie(index: indexPath.row) else { return UITableViewCell() }
        cell.configureCell(with: movieData)
        return cell
    }
}
//MARK: - Constatns
extension ListVC {
    enum Constants {
        static let cellIdentifier = "MovieCell"
    }
}
