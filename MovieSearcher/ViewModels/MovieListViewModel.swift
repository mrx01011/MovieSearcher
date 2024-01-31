//
//  MovieListViewModel.swift
//  MovieSearcher
//
//  Created by MacBook on 30.01.2024.
//

import Foundation

final class MovieListViewModel {
    private let networkManager: NetworkManager
    private var _movies = Dynamic<[Movie]>([])
    private var _genres = Dynamic<[Genre]>([])
    private var page = 1
    
    var movies: Dynamic<[Movie]> {
        return _movies
    }
    
    var genres: Dynamic<[Genre]> {
        return _genres
    }
    
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
        fetchMovie()
        fetchGenres()
    }
    
    private func fetchMovie() {
        networkManager.getMovieList(page: page) { [weak self] result, _  in
            guard let self = self, let result = result else { return }
            _movies.value += result
        }
    }
    
    private func fetchGenres() {
        networkManager.getGenresOfMovies { [weak self] result, _ in
            guard let self = self, let result = result else { return }
            self._genres.value = result
            self.saveGenres()
        }
    }
    
    func getNumberOrRows() -> Int {
        return _movies.value.count
    }
    
    func getMovie(index: Int) -> Movie? {
        return _movies.value[index]
    }
    
    func getPage() -> Int {
        return page
    }
    
    func loadNewPage() {
        page += 1
        fetchMovie()
    }
    
    func saveMovie(at indexPath: IndexPath) {
        CoreDataManager.shared.saveMovie(model: _movies.value[indexPath.row]) { result in
            switch result {
            case .success():
                NotificationCenter.default.post(name: NSNotification.Name("addedToFavorites"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func saveGenres() {
        CoreDataManager.shared.saveGenres(models: _genres.value) { result in
            switch result {
            case .success():
                print("Genres were saved")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
