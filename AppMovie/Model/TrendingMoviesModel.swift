//
//  TrendingMoviesModel.swift
//  AppMovie
//
//  Created by Damir Agadilov  on 27.04.2025.
//

import UIKit

// MARK: - Movie
struct TrendingMoviesModel: Decodable {
    let movieResults: [MovieResult]
    
    enum CodingKeys: String, CodingKey {
        case movieResults = "movie_results"
    }
}

struct MovieResult: Decodable {
    let title: String
    let year: String
    let imdbId: String
    
    enum CodingKeys: String, CodingKey {
        case title, year
        case imdbId = "imdb_id"
    }
}

struct Movie {
    let title: String
    let year: String
    let imdb: String
    let fanart: UIImage
}

struct MovieImage: Decodable {
    let poster: String?
    let fanart: String?
}


// MARK: - MovieDetails
struct MovieDetails: Decodable {
    
    let title: String
    let description: String
    let tagline: String
    let year: String
    let imdbRating: String
    let voteCount: String
    let popularity: String
    let genres: [String]
    let stars: [String]
    let language: [String]
    
    enum CodingKeys: String, CodingKey {
        case title, description, tagline, year, popularity, genres, stars, language
        case imdbRating = "imdb_rating"
        case voteCount = "vote_count"
    }
    
    var numberOfAttributes: Int {
        return Mirror(reflecting: self).children.count
    }
    
    func transformToDataSource() -> [[String: [Any]]] {
        let dataSource: [[String: [Any]]] = [
            ["title": [self.title]],
            ["description": [self.description]],
            ["tagline": [self.tagline]],
            ["year": [self.year]],
            ["imdb Rating": [self.imdbRating]],
            ["vote Count": [self.voteCount]],
            ["popularity": [self.popularity]],
            ["genres": self.genres],
            ["stars": self.stars],
            ["language": self.language]
        ]
        
        return dataSource
    }
}
