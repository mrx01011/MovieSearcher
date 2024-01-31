//
//  MovieListViewModel.swift
//  MovieSearcher
//
//  Created by MacBook on 30.01.2024.
//

import Foundation

final class MovieListViewModel {
    private let networkManager = NetworkManager()
    private var movies = [Movie]()
    private var genres = [Genre]()
    private var page = 1
    
    var isMoviesLoaded: (([Movie]?, Bool) -> Void)?
    
    init() {
        callMovies()
        callGenres()
    }
    
    private func handleResponse(response: [Movie]?, success: Bool) {
        if let moviesLoaded = self.isMoviesLoaded {
            moviesLoaded(response, success)
        }
    }
    
    func callMovies() {
        networkManager.getMovieList(page: page) { [weak self] result, _  in
            guard let self, let result = result else { return }
            self.movies += result
            self.handleResponse(response: result, success: true)
        }
    }
    
    func callGenres() {
        networkManager.getGenresOfMovies { [weak self] result, _ in
            guard let self, let result = result else { return }
            self.genres = result
            self.saveGenres()
        }
    }
    
    func getNumberOrRows() -> Int {
        return self.movies.count
    }
    
    func getMovie(index: Int) -> Movie? {
        return self.movies[index]
    }
    
    func getGenres() -> [Genre] {
        return self.genres
    }
    
    func getPage() -> Int {
        return self.page
    }
    
    func loadNewPage() {
        page += 1
        callMovies()
    }
    
    func saveMovie(at indexPath: IndexPath) {
        CoreDataManager.shared.saveMovie(model: movies[indexPath.row]) { result in
            switch result {
            case .success():
                NotificationCenter.default.post(name: NSNotification.Name("addedToFavorites"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func saveGenres() {
        CoreDataManager.shared.saveGenres(models: genres) { result in
            switch result {
            case .success():
                print("Genres was saved")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
