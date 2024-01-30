//
//  NetworkingService.swift
//  MovieSearcher
//
//  Created by MacBook on 30.01.2024.
//

import Foundation

protocol NetworkingService {
    func getMovieList(page: Int, completionHandler: @escaping ([Movie]?) -> Void)
}

final class NetworkManager: NetworkingService {
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
    
    func getMovieList(page: Int, completionHandler: @escaping ([Movie]?) -> Void) {
        guard let url = NSURL(string: "https://api.themoviedb.org/3/movie/popular?language=en-US&page=\(page)") else { return }
        let request = NSMutableURLRequest(url: url as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, _, _) -> Void in
            guard let data = data,
                  let response = try? JSONDecoder().decode(Movies.self, from: data) else { return }
            completionHandler(response.results)
        })
        dataTask.resume()
    }
}
