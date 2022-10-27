//
//  HomePresenter.swift
//  eMovie
//
//  Created by Leandro Berli on 27/10/2022.
//

import Foundation

protocol HomePresenterProtocol: AnyObject {
    var view: HomeViewProtocol? { get set }
    var httpClient: HTTPClientProtocol? { get set }
    var upcomingMovies: [Movie] { get set }
    var topRatedMovies: [Movie] { get set }
    var recommendedMovies: [Movie] { get set }
    
    func getUpcomingMovies()
    func getTopRatedMovies()
}


class HomePresenter: HomePresenterProtocol {
    
    weak var view: HomeViewProtocol?
    var httpClient: HTTPClientProtocol?
    var upcomingMovies: [Movie] = []
    var topRatedMovies: [Movie] = []
    var recommendedMovies: [Movie] = []

    init(view: HomeViewProtocol, httpClient: HTTPClient) {
        self.view = view
        self.httpClient = httpClient
    }
    
    func getUpcomingMovies() {
        httpClient?.getUpcomingMovies { movies, error in
            self.upcomingMovies = movies ?? []
            DispatchQueue.main.async {
                self.view?.updateCollectionData()
            }
        }
    }
    
    func getTopRatedMovies() {
        httpClient?.getTopRatedMovies { movies, error in
            self.topRatedMovies = movies ?? []
            self.recommendedMovies = Array(self.topRatedMovies.suffix(6))
            DispatchQueue.main.async {
                self.view?.updateCollectionData()
            }
        }
    }
}
