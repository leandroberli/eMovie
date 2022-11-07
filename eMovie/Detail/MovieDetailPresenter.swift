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
    var favorite: Bool { get set }

    func getMovieDetail()
    func getMovieVideoTrailer()
    func didTapFavoriteButton()
}

class MovieDetailPresenter: MovieDetailPresenterProtocol {
    
    weak var view: MovieDetailViewProtocol?
    var movie: Movie?
    var interactor: MovieDetailInteractorProtocol?
    var favorite: Bool = false
    
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
        
        interactor?.getAvailablePlataforms(movieName: movie?.original_title ?? "") { res, err in
            DispatchQueue.main.async {
                self.view?.updateMovieProviders(data: res)
            }
        }
    }
    
    func didTapFavoriteButton() {
        let fav = self.favorite
        self.favorite = !fav
        interactor?.markAsFavorite(favorite: favorite, movieId: movie?.id ?? 0)
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
