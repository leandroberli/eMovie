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
    var interactor: MovieDetailInteractorProtocol? { get set }

    func getMovieDetail()
    func getMovieVideoTrailer()
}

class MovieDetailPresenter: MovieDetailPresenterProtocol {
    
    weak var view: MovieDetailViewProtocol?
    var movie: Movie?
    var interactor: MovieDetailInteractorProtocol?
    
    init(movie: Movie, view: MovieDetailViewProtocol, interactor: MovieDetailInteractorProtocol) {
        self.movie = movie
        self.view = view
        self.interactor = interactor
    }
    
    func getMovieDetail() {
        interactor?.getMovieDetail(withId: movie?.id ?? 0) { detail, error in
            DispatchQueue.main.async {
                self.view?.updateViewWithMovie(data: detail)
            }
        }
    }
    
    func getMovieVideoTrailer() {
        interactor?.getMovieVideoTrailer(withId: movie?.id ?? 0) { trailer, error in
            guard let url = trailer?.getVideoURLRequest() else {
                return
            }
            DispatchQueue.main.async {
                self.view?.updateTrailerWebview(withURLRequest: url)
            }
        }
    }
}
