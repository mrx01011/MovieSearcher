//
//  FavoritesViewModel.swift
//  MovieSearcher
//
//  Created by MacBook on 30.01.2024.
//

import Foundation

final class FavoritesViewModel {
    private let networkManager: NetworkManager
    private var _favorites = Dynamic<[Movie]>([])
    private var _genres = Dynamic<[Genre]>([])
    
    var favorites: Dynamic<[Movie]> {
        return _favorites
    }
    
    var gengres: Dynamic<[Genre]> {
        return _genres
    }
    
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager        
        fetchData()
        fetchGenres()
        addObservers()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("addedToFavorites"), object: nil, queue: nil) { [weak self] _ in
            guard let self = self else { return }
            self.fetchData()
        }
    }
    
    func fetchGenres() {
        CoreDataManager.shared.fetchGenres { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let genres):
                self._genres.value = genres
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchData() {
        CoreDataManager.shared.fetchMovies { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let favorites):
                self._favorites.value = favorites
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteMovie(at indexPath: IndexPath) {
        CoreDataManager.shared.deleteMovie(model: _favorites.value[indexPath.row]) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success():
                var updatedFavorites = self._favorites.value
                updatedFavorites.remove(at: indexPath.row)
                self._favorites.value = updatedFavorites
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getNumberOrRows() -> Int {
        return _favorites.value.count
    }
    
    func getMovie(index: Int) -> Movie? {
        return _favorites.value[index]
    }
}
