//
//  HomeInteractor.swift
//  eMovie
//
//  Created by Leandro Berli on 31/10/2022.
//

import Foundation

protocol HomeInteractorProtocol: GetProvidersProcessDelegate {
    var httpClient: HTTPClient? { get set }
    var presenter: HomePresenterProtocol? { get set }
    var providersProcess: GetProvidersProcessProtocol? { get set }
    
    func getTopRatedMovies(page: Int)
    func getUpcomingMovies(page: Int)
    func getRecommendedMovies(page: Int)
    func generateMoviesWarappers(_ movies: [Movie], forSection: HomeViewController.Section) -> [MovieWrapper]
    func getProviders(forMovies: [MovieWrapper])
}

class HomeInteractor: HomeInteractorProtocol {
    var providersProcess: GetProvidersProcessProtocol? = GetProvidersProcess()
    var presenter: HomePresenterProtocol?
    var httpClient: HTTPClient? = HTTPClient()
    
    init(httpClient: HTTPClient, providerProcess: GetProvidersProcessProtocol) {
        self.httpClient = httpClient
        self.providersProcess = providerProcess
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
        providersProcess?.startProcess(forMovies: forMovies)
    }
    
    func generateMoviesWarappers(_ movies: [Movie], forSection: HomeViewController.Section) -> [MovieWrapper] {
        let wrappers = movies.map({ return MovieWrapper(section: forSection, movie: $0)})
        return wrappers
    }
}

extension HomeInteractor: GetProvidersProcessDelegate {
    func providersDataReceived(_ data: [String : [ProviderPlataform]], forSection: HomeViewController.Section) {
        self.presenter?.didReceivedProvidersData(data: .success(data), fromSection: forSection)
    }
}
