//
//  MovieViewModel.swift
//  MovieDatabase
//
//  Created by Shabuddin SA on 13/10/24.
//

import Foundation

class MovieViewModel {
    var allMovies: [Movie] = []
    var filteredMovies: [Movie] = []
    
    func loadMovies(completion: @escaping (Error?) -> Void) {
        guard let url = Bundle.main.url(forResource: "movies", withExtension: "json") else {
            completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "File not found"]))
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            allMovies = try JSONDecoder().decode([Movie].self, from: data)
            filteredMovies = allMovies // Start with all movies
            completion(nil)
        } catch {
            completion(error)
        }
    }
    func filterMoviesByCategory(_ category: String) {
            // Clear previous filtered results
            filteredMovies = []

            // Check if the category is a year
            if let year = Int(category) {
                filteredMovies = allMovies.filter { $0.year == "\(year)" }
                return
            }

            // Check for genre filtering
            filteredMovies = allMovies.filter { movie in
                if let genre = movie.genre {
                    return genre.contains(category)
                }
                return false
            }

            // Check for actor filtering
            if filteredMovies.isEmpty {
                filteredMovies = allMovies.filter { movie in
                    if let actors = movie.actors {
                        return actors.contains(category)
                    }
                    return false
                }
            }

            // Check for director filtering
            if filteredMovies.isEmpty {
                filteredMovies = allMovies.filter { movie in
                    return movie.director == category
                }
            }
            
            // If no filtering criteria matched, consider the "All Movies" option
            if filteredMovies.isEmpty && category == "All Movies" {
                filteredMovies = allMovies
            }
        }
    
    
    func filterMovies(searchText: String) {
        if searchText.isEmpty {
            filteredMovies = allMovies
        } else {
            filteredMovies = allMovies.filter {
                ($0.title?.lowercased().contains(searchText.lowercased()) ?? false) ||
                ($0.actors?.lowercased().contains(searchText.lowercased()) ?? false) ||
                ($0.director?.lowercased().contains(searchText.lowercased()) ?? false) ||
                ($0.genre?.lowercased().contains(searchText.lowercased()) ?? false)
            }
        }
    }
}
