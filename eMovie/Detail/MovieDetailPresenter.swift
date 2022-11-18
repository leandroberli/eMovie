//
//  DetailMoviePresenter.swift
//  eMovie
//
//  Created by Leandro Berli on 28/10/2022.
//

import Foundation
import UIKit

typealias MovieDetailView = MovieDetailViewProtocol & UIViewController

protocol MovieDetailPresenterProtocol {
    var movie: Movie? { get set }
    var platforms: ItemMovieProvider? { get set }
    var view: MovieDetailView? { get set }
    var interactor: MovieDetailInteractorProtocol? { get set }
    var favorite: Bool { get set }
    var router: MovieDetailRouterProtocol? { get set }

    func getMovieDetail()
    func getMovieVideoTrailer()
    func didTapFavoriteButton()
    func getAvailablePlatfroms()
    func navigateToPlatformURL(platformIndex: Int)
}

class MovieDetailPresenter: MovieDetailPresenterProtocol {
    var platforms: ItemMovieProvider?
    var router: MovieDetailRouterProtocol?
    weak var view: MovieDetailView?
    var movie: Movie?
    var interactor: MovieDetailInteractorProtocol?
    var favorite: Bool = false
    
    init(movie: Movie, view: MovieDetailView, interactor: MovieDetailInteractorProtocol, router: MovieDetailRouterProtocol) {
        self.movie = movie
        self.view = view
        self.interactor = interactor
        self.router = router
        RecentMoviesViewedHandler.shared.addViewed(movie: movie)
    }
    
    func getMovieDetail() {
        interactor?.getMovieDetail(withId: movie?.id ?? 0) { detail, error in
            DispatchQueue.main.async {
                self.view?.updateViewWithMovie(data: detail)
            }
        }
    }
    
    func getAvailablePlatfroms() {
        interactor?.getAvailablePlataforms(movieName: movie?.original_title ?? "") { res, err in
            DispatchQueue.main.async {
                if let res = res {
                    self.platforms = res
                    self.view?.updateMovieProviders(data: res)
                }
            }
        }
    }
    
    @objc func navigateToPlatformURL(platformIndex: Int) {
        let url = platforms?.platforms?[platformIndex].url ?? ""
        router?.navigateToSafariController(fromView: self.view, url: url)
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
