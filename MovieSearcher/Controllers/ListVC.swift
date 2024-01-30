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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var moviesTableView: UITableView!
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultConfigurations()
        setupDelegates()
        refreshData()
    }
    //MARK: Private methods
    private func defaultConfigurations() {
        title = "Movies List"
        view.backgroundColor = .white
        moviesTableView.register(MovieTableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
    }
    
    private func setupDelegates() {
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
    }
    
    private func refreshData() {
        activityIndicator.startAnimating()
        self.movieListViewModel.isMoviesLoaded = { [weak self] (_, success) in
            guard let self else { return }
            if success {
                self.moviesTableView.reloadData()
            }
        }
        activityIndicator.stopAnimating()
    }
}
//MARK: - UITableViewDelegate, UITableViewDataSource
extension ListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieListViewModel.getNumberOrRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier) as? MovieTableViewCell,
              let movieData = movieListViewModel.getMovie(index: indexPath.row) else { return UITableViewCell() }
        cell.configureCell(with: movieData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let movieData = movieListViewModel.getMovie(index: indexPath.row) else { return }
        let detailVC = DetailMovieVC(with: movieData)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if Int(scrollView.contentOffset.y) >= Int(1.8 * moviesTableView.bounds.height) * movieListViewModel.getPage() {
            movieListViewModel.loadNewPage()
            refreshData()
        }
    }
}
//MARK: - Constatns
extension ListVC {
    enum Constants {
        static let cellIdentifier = "MovieCell"
    }
}
