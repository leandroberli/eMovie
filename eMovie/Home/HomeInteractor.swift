//
//  HomeInteractor.swift
//  eMovie
//
//  Created by Leandro Berli on 31/10/2022.
//

import Foundation

protocol HomeInteractorProtocol {
    var httpClient: HTTPClient? { get set }
    
    func getTopRatedMovies(page: Int, completion: @escaping (ResultReponse<Movie>?,Error?) -> Void)
    func getUpcomingMovies(page: Int, completion: @escaping (ResultReponse<Movie>?,Error?) -> Void)
    func getRecommendedMovies(page: Int, completion: @escaping (ResultReponse<Movie>?,Error?) -> Void)
    func getMovieProviders(for movieName: String, callback: @escaping ([ProviderPlataform]?,Error?) -> Void)
    func generateMoviesWarappers(_ movies: [Movie], forSection: HomeViewController.Section) -> [MovieWrapper]
}

class HomeInteractor: HomeInteractorProtocol {
    func getMovieProviders(for movieName: String, callback: @escaping ([ProviderPlataform]?,Error?) -> Void) {
        MovieProviderClient().getMovieProvider(movieName: movieName ) { itemProvider, error in
            let providersArray = itemProvider?.platforms ?? []
            callback(providersArray,nil)
        }
    }
    
    var httpClient: HTTPClient? = HTTPClient()
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func getTopRatedMovies(page: Int,completion: @escaping ( ResultReponse<Movie>?, Error?) -> Void) {
        httpClient?.getTopRatedMovies(page: page) { res, error in
            guard let data = res, error == nil else {
                return
            }
            //let wrappers = self.generateMoviesWarappers(movies?.results forSection: .topRated)
            completion(data, error)
        }
    }
    
    func getUpcomingMovies(page: Int,completion: @escaping (ResultReponse<Movie>?, Error?) -> Void) {
        httpClient?.getUpcomingMovies(page: page) { res, error in
            completion(res, error)
        }
    }
    
    func getRecommendedMovies(page: Int,completion: @escaping (ResultReponse<Movie>?, Error?) -> Void) {
        httpClient?.getTopRatedMovies(page: page) { res, error in
            completion(res, error)
        }
    }
    
    func generateMoviesWarappers(_ movies: [Movie], forSection: HomeViewController.Section) -> [MovieWrapper] {
        let wrappers = movies.map({ return MovieWrapper(section: forSection, movie: $0)})
        return wrappers
    }
}
