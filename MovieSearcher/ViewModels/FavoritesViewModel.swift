//
//  FavoritesViewModel.swift
//  MovieSearcher
//
//  Created by MacBook on 30.01.2024.
//

import Foundation

final class FavoritesViewModel {
    private let networkManager = NetworkManager()
    private var favorites = [Movie]()
    
    var onMoviesFavorited: (([Movie]?, Bool) -> Void)?
    
    init() {
        fetchData()
        addObservers()
    }
    
    private func handleResponse(response: [Movie]?, success: Bool) {
        if let moviesFavorited = self.onMoviesFavorited {
            moviesFavorited(response, success)
        }
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("addedToFavorites"), object: nil, queue: nil) { [weak self] _ in
            guard let self else { return }
            self.fetchData()
        }
    }
    
    func getGenres() -> [Genre] {
        var genres = [Genre]()
        CoreDataManager.shared.fetchGenres { result in
            switch result {
            case .success(let data):
                genres = data
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        return genres
    }
    
    func fetchData() {
        CoreDataManager.shared.fetchMovies { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let favorites):
                self.favorites = favorites
                handleResponse(response: favorites, success: true)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteMovie(at indexPath: IndexPath) {
        CoreDataManager.shared.deleteMovie(model: favorites[indexPath.row]) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success():
                self.favorites.remove(at: indexPath.row)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getNumberOrRows() -> Int {
        return self.favorites.count
    }
    
    func getMovie(index: Int) -> Movie? {
        return self.favorites[index]
    }
}
