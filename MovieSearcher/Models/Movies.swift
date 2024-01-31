//
//  Movies.swift
//  MovieSearcher
//
//  Created by MacBook on 30.01.2024.
//

import Foundation

// MARK: Movies
struct Movies: Codable {
    let page: Int
    let results: [Movie]
}

// MARK: Result
struct Movie: Codable {
    let id: Int
    let overview: String
    let popularity: Double
    let posterPath: String
    let releaseDate: String
    let title: String
    let voteAverage: Double
    let genreIDS: [Int]

    enum CodingKeys: String, CodingKey {
        case id
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
        case genreIDS = "genre_ids"
    }
}
