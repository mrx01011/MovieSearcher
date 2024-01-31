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
    
    private init() {}
    
    func saveMovie(model: Movie, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
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
            }
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToSaveData))
        }
    }
    
    func fetchMovies(completion: @escaping (Result<[Movie],Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
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
                    genreIDS: movieItem.genresIDS ?? []
                )
            }
            completion(.success(movies))
        } catch {
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }
    
    func deleteMovie(model: Movie, completion: @escaping (Result<Void,Error>)->Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<MovieItem> = MovieItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", model.id)
        
        do {
            if let movieItem = try context.fetch(fetchRequest).first {
                context.delete(movieItem)
                try context.save()
                completion(.success(()))
            }
        } catch {
            completion(.failure(DatabaseError.failedToDeleteData))
        }
    }
}
//MARK: - DataBaseError
extension CoreDataManager {
    enum DatabaseError: Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
    }
}
