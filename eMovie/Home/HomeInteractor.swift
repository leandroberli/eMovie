//
//  HomeInteractor.swift
//  eMovie
//
//  Created by Leandro Berli on 31/10/2022.
//

import Foundation

protocol HomeInteractorProtocol {
    var httpClient: HTTPClient? { get set }
    var providerClient: MovieProviderClient? { get set}
    var presenter: HomePresenterProtocol? { get set }
    
    func getTopRatedMovies(page: Int)
    func getUpcomingMovies(page: Int)
    func getRecommendedMovies(page: Int)
    func generateMoviesWarappers(_ movies: [Movie], forSection: HomeViewController.Section) -> [MovieWrapper]
    func getProviders(forMovies: [MovieWrapper])
}

class HomeInteractor: HomeInteractorProtocol {
    var providerClient: MovieProviderClient? = MovieProviderClient()
    var presenter: HomePresenterProtocol?
    var httpClient: HTTPClient? = HTTPClient()
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func getTopRatedMovies(page: Int) {
        httpClient?.getTopRatedMovies(page: page) { res, error in
            guard let data = res, error == nil else {
                return
            }
            let wrappers = self.generateMoviesWarappers(data.results, forSection: .topRated)
            self.presenter?.didReceivedTopRatedMovies(data: .success(wrappers))
        }
    }
    
    func getUpcomingMovies(page: Int) {
        httpClient?.getUpcomingMovies(page: page) { res, error in
            let wrappers = res?.results.map({ MovieWrapper(section: .upcoming, movie: $0)}) ?? []
            self.presenter?.didReceivedUpcomingMovies(data: .success(wrappers))
        }
    }
    
    func getRecommendedMovies(page: Int) {
        httpClient?.getTopRatedMovies(page: page) { res, error in
            let wrappers = self.generateMoviesWarappers(res?.results ?? [], forSection: .recommended)
            self.presenter?.didReceivedRecommendedMovies(data: .success(wrappers))
        }
    }
    
    func getProviders(forMovies: [MovieWrapper]) {
        let section = forMovies.first?.section ?? .topRated
        let group = DispatchGroup()
        var providers: [String: [ProviderPlataform]] = [:]
        
        forMovies.forEach({
            group.enter()
            
            let movieName = $0.movie.original_title ?? ""
            providerClient?.getMovieProvider(movieName: movieName) { res, err in
                if let provs = res?.platforms {
                    providers.updateValue(provs, forKey: movieName)
                }
                group.leave()
            }
        })
        
        group.notify(queue: .main) {
            print("ALL PROVIDER REQUEST FROM SECTION \(section.title) FINISHED")
            self.presenter?.didReceivedProvidersData(data: .success(providers), fromSection: section)
        }
    }
    
    func generateMoviesWarappers(_ movies: [Movie], forSection: HomeViewController.Section) -> [MovieWrapper] {
        let wrappers = movies.map({ return MovieWrapper(section: forSection, movie: $0)})
        return wrappers
    }
}
