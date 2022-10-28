//
//  DetailMoviePresenter.swift
//  eMovie
//
//  Created by Leandro Berli on 28/10/2022.
//

import Foundation

protocol MovieDetailPresenterProtocol {
    var movie: Movie? { get set }
    var view: MovieDetailViewProtocol? { get set }
    var httpClient: HTTPClientProtocol? { get set }
    
    func getMovieDetail()
}

class MovieDetailPresenter: MovieDetailPresenterProtocol {
    
    weak var view: MovieDetailViewProtocol?
    var movie: Movie?
    var httpClient: HTTPClientProtocol?
    
    init(movie: Movie, view: MovieDetailViewProtocol, httpClient: HTTPClientProtocol) {
        self.movie = movie
        self.view = view
        self.httpClient = httpClient
    }
    
    func getMovieDetail() {
        httpClient?.getDetailMovie(withId: self.movie?.id ?? 0) { detail, error in
            DispatchQueue.main.async {
                self.view?.updateViewWithMovie(data: detail)
            }
        }
    }
}
