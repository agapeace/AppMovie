//
//  FirstViewModel.swift
//  AppMovie
//
//  Created by Damir Agadilov  on 27.04.2025.
//

import UIKit

class FirstViewModel {
    
    var observableValue: ObservableObjectSecondScreen<MovieDetails> = ObservableObjectSecondScreen(valueArr: [])
    var firstSectionObservable = ObservableObject<Movie>(valueArr: [])
    var secondSectionObservable = ObservableObject<Movie>(valueArr: [])
    var thirdSectionObservable = ObservableObject<Movie>(valueArr: [])
    
    func fetAllMovies() {
        Task { [weak self] in
            guard let self = self else { return }
            async let firstSection = NetworkManager.shared.fetchTrendingMovies(page: 0, isPoster: false)
            async let secondSection = NetworkManager.shared.fetchTrendingMovies(page: 2, isPoster: true)
            async let thirdSection = NetworkManager.shared.fetchTrendingMovies(page: 3, isPoster: true)

            do {
                let firstData = try await firstSection
                let secondData = try await secondSection
                let thirdData = try await thirdSection
                            
                
                self.firstSectionObservable.valueArr = firstData
                self.secondSectionObservable.valueArr = secondData
                self.thirdSectionObservable.valueArr = thirdData

            } catch {
                print("Error fetching movies: \(error)")
            }
        }
    }
    
    func fetchMovieById(movieId: String) {
        Task { [weak self] in
            guard let self = self else { return }

            do {
                let movieDetails = try await NetworkManager.shared.fetchMovieById(movieId: movieId)
                self.observableValue.valueArr = movieDetails
            } catch {
                print("Error fetching movie details: \(error)")
            }
        }
    }
    
    func pushDetailsViewController(navigation: UIViewController, currentMovie: Movie, isPoster: Bool) {
        let vc = MovieDetailViewController(movie: currentMovie, isPoster: isPoster)
        
        navigation.navigationController?.pushViewController(vc, animated: true)
    }
}
