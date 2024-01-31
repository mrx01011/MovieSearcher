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
        setupBindings()
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
    
    private func setupBindings() {
        movieListViewModel.movies.bind { [weak self] _ in
            self?.moviesTableView.reloadData()
        }
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
        let genres = movieListViewModel.genres.value
        let detailVC = DetailMovieVC(with: movieData, genres: genres)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if Int(scrollView.contentOffset.y) >= Int(2 * moviesTableView.bounds.height) * movieListViewModel.getPage() {
            movieListViewModel.loadNewPage()
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(actionProvider: { [weak self] _ in
            let downloadAction = UIAction(title: "Add to favorites", state: .off) { _ in
                guard let self else { return }
                self.movieListViewModel.saveMovie(at: indexPath)
            }
            return UIMenu(options: .displayInline, children: [downloadAction])
        })
        return config
    }
}
//MARK: - Constatns
extension ListVC {
    enum Constants {
        static let cellIdentifier = "MovieCell"
    }
}
