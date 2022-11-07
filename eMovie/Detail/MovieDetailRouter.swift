//
//  DetailRouter.swift
//  eMovie
//
//  Created by Leandro Berli on 01/11/2022.
//

import Foundation
import UIKit
import SafariServices

protocol MovieDetailRouterProtocol {
    static func createMovieDetailModule(forMovie: Movie) -> UIViewController
    func navigateToSafariController(fromView: MovieDetailView?, url: String)
}

class MovieDetailRouter: MovieDetailRouterProtocol {
    static func createMovieDetailModule(forMovie: Movie) -> UIViewController {
        let detailView = MovieDetailViewController()
        let interactor = MovieDetailInteractor(httpClient: HTTPClient())
        let presenter = MovieDetailPresenter(movie: forMovie, view: detailView, interactor: interactor, router: MovieDetailRouter())
        detailView.presenter = presenter
        return detailView
    }
    
    func navigateToSafariController(fromView: MovieDetailView?, url: String) {
        guard let url = URL(string: url) else { return }
        let safariController = SFSafariViewController(url: url)
        fromView?.present(safariController, animated: true)
    }
}
