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
    private var page = 1
    
    var isMoviesLoaded: (([Movie]?, Bool) -> Void)?
    
    init() {
        callRequest()
    }
    
    func callRequest() {
        networkManager.getMovieList(page: page) { [weak self] result, _  in
            guard let self,
                  let result = result else { return }
            self.movies = result
            self.handleResponse(response: result, success: true)
        }
    }
    
    private func handleResponse(response: [Movie]?, success: Bool) {
        if let moviesLoaded = self.isMoviesLoaded {
            moviesLoaded(response, success)
        }
    }
    
    func numberOrRows() -> Int {
        return self.movies.count
    }
    
    func getMovie(index: Int) -> Movie? {
        return self.movies[index]
    }
}
