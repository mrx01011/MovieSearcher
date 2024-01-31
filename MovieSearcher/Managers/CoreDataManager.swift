//
//  CoreDataManager.swift
//  MovieSearcher
//
//  Created by MacBook on 30.01.2024.
//

import UIKit
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private let context: NSManagedObjectContext
    
    private init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unable to get the AppDelegate")
        }
        self.context = appDelegate.persistentContainer.viewContext
    }
    
    func saveMovie(model: Movie, completion: @escaping (Result<Void, Error>) -> Void) {
        let fetchRequest: NSFetchRequest<MovieItem> = MovieItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", model.id)
        
        do {
            if let existingMovieItem = try context.fetch(fetchRequest).first {
                print("Duplicate - \(String(describing: existingMovieItem.title))")
            } else {
                let newItem = MovieItem(context: context)
                newItem.id = Int32(model.id)
                newItem.popularity = model.popularity
                newItem.posterPath = model.posterPath
                newItem.title = model.title
                newItem.overview = model.overview
                newItem.releaseDate = model.releaseDate
                newItem.voteAverage = model.voteAverage
                newItem.genresIDS = model.genreIDS
                newItem.backdropPath = model.backdropPath
            }
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(CoreDataError.failedToSaveData))
        }
    }
    
    func fetchMovies(completion: @escaping (Result<[Movie],Error>) -> Void) {
        let request: NSFetchRequest<MovieItem>
        
        request = MovieItem.fetchRequest()
        
        do {
            let movieItems = try context.fetch(request)
            let movies = movieItems.map { movieItem -> Movie in
                return Movie(
                    id: Int(movieItem.id),
                    overview: movieItem.overview ?? "",
                    popularity: movieItem.popularity,
                    posterPath: movieItem.posterPath ?? "",
                    releaseDate: movieItem.releaseDate ?? "",
                    title: movieItem.title ?? "",
                    voteAverage: movieItem.voteAverage,
                    genreIDS: movieItem.genresIDS ?? [],
                    backdropPath: movieItem.backdropPath ?? ""
                )
            }
            completion(.success(movies))
        } catch {
            completion(.failure(CoreDataError.failedToFetchData))
        }
    }
    
    func deleteMovie(model: Movie, completion: @escaping (Result<Void,Error>)->Void) {
        let fetchRequest: NSFetchRequest<MovieItem> = MovieItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", model.id)
        
        do {
            if let movieItem = try context.fetch(fetchRequest).first {
                context.delete(movieItem)
                try context.save()
                completion(.success(()))
            }
        } catch {
            completion(.failure(CoreDataError.failedToDeleteData))
        }
    }
    
    func saveGenres(models: [Genre], completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            for model in models {
                let genreItem = GenreItem(context: context)
                genreItem.id = Int32(model.id)
                genreItem.name = model.name
            }
            
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(CoreDataError.failedToSaveData))
        }
    }
    
    func fetchGenres(completion: @escaping (Result<[Genre], Error>) -> Void) {
        let request: NSFetchRequest<GenreItem> = GenreItem.fetchRequest()
        
        do {
            let genreItems = try context.fetch(request)
            let genres = genreItems.map { genreItem -> Genre in
                return Genre(
                    id: Int(genreItem.id),
                    name: genreItem.name ?? ""
                )
            }
            completion(.success(genres))
        } catch {
            completion(.failure(CoreDataError.failedToFetchData))
        }
    }
}
//MARK: - CoreDataError
extension CoreDataManager {
    enum CoreDataError: Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
    }
}
