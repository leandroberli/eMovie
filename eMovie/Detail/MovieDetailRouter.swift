//
//  DetailRouter.swift
//  eMovie
//
//  Created by Leandro Berli on 01/11/2022.
//

import Foundation
import UIKit

protocol MovieDetailRouterProtocol {
    static func createMovieDetailModule(forMovie: Movie) -> UIViewController
}

class MovieDetailRouter: MovieDetailRouterProtocol {
    static func createMovieDetailModule(forMovie: Movie) -> UIViewController {
        let detailView = MovieDetailViewController()
        let interactor = MovieDetailInteractor(httpClient: HTTPClient())
        let presenter = MovieDetailPresenter(movie: forMovie, view: detailView, interactor: interactor)
        detailView.presenter = presenter
        return detailView
    }
}
