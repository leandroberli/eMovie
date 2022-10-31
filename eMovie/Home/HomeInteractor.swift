//
//  HomeInteractor.swift
//  eMovie
//
//  Created by Leandro Berli on 31/10/2022.
//

import Foundation

protocol HomeInteractorProtocol {
    var httpClient: HTTPClient? { get set }
    func getTopRatedMovies(completion: @escaping ([MovieWrapper]?,Error?) -> Void)
    func getUpcomingMovies(completion: @escaping ([MovieWrapper]?,Error?) -> Void)
    func getRecommendedMovies(completion: @escaping ([MovieWrapper]?,Error?) -> Void)
}

class HomeInteractor: HomeInteractorProtocol {
    var httpClient: HTTPClient? = HTTPClient()
    
    func getTopRatedMovies(completion: @escaping ([MovieWrapper]?, Error?) -> Void) {
        httpClient?.getTopRatedMovies { movies, error in
            let wrappers = self.generateMoviesWarappers(movies ?? [], forSection: .topRated)
            completion(wrappers, error)
        }
    }
    
    func getUpcomingMovies(completion: @escaping ([MovieWrapper]?, Error?) -> Void) {
        httpClient?.getUpcomingMovies { movies, error in
            let wrappers = self.generateMoviesWarappers(movies ?? [], forSection: .upcoming)
            completion(wrappers, error)
        }
    }
    
    func getRecommendedMovies(completion: @escaping ([MovieWrapper]?, Error?) -> Void) {
        httpClient?.getTopRatedMovies { movies, error in
            let wrappers = self.generateMoviesWarappers(movies ?? [], forSection: .recommended)
            completion(wrappers, error)
        }
    }
    
    func generateMoviesWarappers(_ movies: [Movie], forSection: HomeViewController.Section) -> [MovieWrapper] {
        let wrappers = movies.map({ return MovieWrapper(section: forSection, movie: $0)})
        return wrappers
    }
}
