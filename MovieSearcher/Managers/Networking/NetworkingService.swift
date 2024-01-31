//
//  NetworkingService.swift
//  MovieSearcher
//
//  Created by MacBook on 30.01.2024.
//

import Foundation

protocol NetworkingService {
    func getMovieList(page: Int, completionHandler: @escaping ([Movie]?, Error?) -> Void)
    func getGenresOfMovies(completionHandler: @escaping ([Genre]?, Error?) -> Void)
}

final class NetworkManager: NetworkingService {
    private let queue = DispatchQueue(label: "NetworkManager_working_queue")
    private let session: URLSession
    private let headers = [
        "accept": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4YmQyNzY0OWYyNGViM2Q0MTI1YWJjN2ViYWQ5ZTRiOSIsInN1YiI6IjY1YjdhMjIwOWJhODZhMDE3YmY5YzRhMiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.mEE5GpmHrFkKHxCfKFgRIi3jO90Bfy3lNPlgkm-IStQ"
    ]
    
    init() {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        session = URLSession.init(configuration: config)
    }
    
    func getMovieList(page: Int, completionHandler: @escaping ([Movie]?, Error?) -> Void) {
        queue.async {
            guard let url = URL(string: APIConstants.baseUrl + APIConstants.popularMoviesUrl + "&page=\(page)") else {
                completionHandler(nil, NetworkingError.invalidURL)
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = self.headers
            
            let dataTask = self.session.dataTask(with: request) { (data, _, error) in
                if let error = error {
                    completionHandler(nil, error)
                    return
                }
                
                guard let data = data else {
                    completionHandler(nil, NetworkingError.noDataReceived)
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(Movies.self, from: data)
                    DispatchQueue.main.async {
                        completionHandler(response.results, nil)
                    }
                } catch {
                    completionHandler(nil, NetworkingError.decodingError)
                }
            }
            dataTask.resume()
        }
    }
    
    func getGenresOfMovies(completionHandler: @escaping ([Genre]?, Error?) -> Void) {
        queue.async {
            guard let url = URL(string: APIConstants.baseUrl + APIConstants.genreListUrl) else {
                completionHandler(nil, NetworkingError.invalidURL)
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = self.headers
            
            let dataTask = self.session.dataTask(with: request) { (data, _, error) in
                if let error = error {
                    completionHandler(nil, error)
                    return
                }
                
                guard let data = data else {
                    completionHandler(nil, NetworkingError.noDataReceived)
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(Genres.self, from: data)
                    DispatchQueue.main.async {
                        completionHandler(response.genres, nil)
                    }
                } catch {
                    completionHandler(nil, NetworkingError.decodingError)
                }
            }
            dataTask.resume()
        }
    }
}
//MARK: - Constants
extension NetworkManager {
    enum APIConstants {
        static let baseUrl = "https://api.themoviedb.org/3"
        static let popularMoviesUrl = "/movie/popular?language=en-US"
        static let genreListUrl = "/genre/movie/list?language=en"
    }
    
    enum NetworkingError: Error {
        case invalidURL
        case noDataReceived
        case decodingError
    }
}

