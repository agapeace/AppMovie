//
//  NetworkManager.swift
//  AppMovie
//
//  Created by Damir Agadilov  on 27.04.2025.
//

import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchTrendingMovies(page: Int, isPoster: Bool) async throws -> [Movie]{
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "movies-tv-shows-database.p.rapidapi.com"
        
        urlComponents.queryItems = [URLQueryItem(name: "page", value: "\(page)")]
        
        let headers = [
            "x-rapidapi-key": "67f240ff7fmsh64dfd6cca767880p138221jsnc8d70bdfaee9",
            "Type": "get-trending-movies"
        ]
        
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = "GET"
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let parsedData = try JSONDecoder().decode(TrendingMoviesModel.self, from: data)
            
            print("Parsed data")
            print(parsedData.movieResults.count)
            print(parsedData.movieResults[0])
            
            let fetchedMoviesWithImages = try await fetchMovieImage(array: parsedData.movieResults, isPoster: isPoster)
            
            print(fetchedMoviesWithImages[0])
            
            return fetchedMoviesWithImages
        } catch {
            print("Error fetching movies: \(error)")
            throw error
        }
    }
    
    func fetchMovieImage(array: [MovieResult], isPoster: Bool) async throws -> [Movie] {
        
        var moviesWithImages = [Movie]()
        
        await withTaskGroup(of: (MovieResult, UIImage?).self) { taskGroup in
            for movieModel in array {
                taskGroup.addTask { [weak self] in
                    guard self != nil else { return (movieModel, nil) }
                    do {
                        var urlComponents = URLComponents()
                        urlComponents.scheme = "https"
                        urlComponents.host = "movies-tv-shows-database.p.rapidapi.com"
                        urlComponents.queryItems = [URLQueryItem(name: "movieid", value: "\(movieModel.imdbId)")]
                        
                        let headers = [
                            "x-rapidapi-key": "67f240ff7fmsh64dfd6cca767880p138221jsnc8d70bdfaee9",
                            "Type": "get-movies-images-by-imdb"
                        ]
                        
                        guard let url = urlComponents.url else {
                            throw URLError(.badURL)
                        }
                        
                        var request = URLRequest(url: url)
                        request.allHTTPHeaderFields = headers
                        request.httpMethod = "GET"
                        
                        let (data, _) = try await URLSession.shared.data(for: request)
                        let parsedData = try JSONDecoder().decode(MovieImage.self, from: data)
                        
                
                
                        guard let posterURL = isPoster ? parsedData.poster : parsedData.fanart, let imageURL = URL(string: posterURL) else {
                            return (movieModel, nil)
                        }
                        
                        if let cachedImage = CacheManager.shared.getCacheObject(forKey: posterURL) {
                            print("Png was retrieved from cache")
                            return (movieModel, cachedImage)
                        }
                        
                        let (data2, _) = try await URLSession.shared.data(from: imageURL)
                        
                        guard let image = UIImage(data: data2) else {
                            throw URLError(.cannotDecodeContentData)
                        }
                        
                        CacheManager.shared.setCacheObject(object: image, forKey: posterURL)
                        return (movieModel, image)
                    }catch {
                        print("Error fetching image for \(movieModel.title): \(error)")
                        return (movieModel, nil)
                    }
                    
                }
            }
            
            for await (movieModel, image) in taskGroup {
                
                if let correctImage = image{
                    let movie = Movie(
                        title: movieModel.title,
                        year: movieModel.year,
                        imdb: movieModel.imdbId,
                        fanart: correctImage)
                    moviesWithImages.append(movie)
                }
            }
            
        }
        
        return moviesWithImages
    }
    
    func fetchMovieById(movieId: String) async throws -> [[String: Any]] {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "movies-tv-shows-database.p.rapidapi.com"
        urlComponents.queryItems = [
            URLQueryItem(name: "movieid", value: "\(movieId)"),
            URLQueryItem(name: "cache_buster", value: UUID().uuidString)
        ]
        
        let headers = [
            "x-rapidapi-key": "67f240ff7fmsh64dfd6cca767880p138221jsnc8d70bdfaee9",
            "Type": "get-movie-details"
        ]
        
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = "GET"
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("JSON Response: \(jsonString)")
            }
            
            let parsedData = try JSONDecoder().decode(MovieDetails.self, from: data)
            
            return parsedData.transformToDataSource()
        } catch {
            print("Error: \(error)")
            throw error
        }
    }
}
