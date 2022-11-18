//
//  SearchRouter.swift
//  eMovie
//
//  Created by Leandro Berli on 05/11/2022.
//

import Foundation
import UIKit

protocol SearchRouterProtocol {
    static func createSearchModule() -> UIViewController
    func navigateToMovieDetail(from: SearchView?, movie: Movie)
}

class SearchRouter: SearchRouterProtocol {
    static func createSearchModule() -> UIViewController {
        var searchController: SearchView = SearchViewController()
        let item = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"))
        searchController.tabBarItem = item
        
        let router: SearchRouterProtocol = SearchRouter()
        var interactor: SearchInteractorProtocol = SearchInteractor(httpClient: HTTPClient())
        let presenter = SearchPresenter(view: searchController, interactor: interactor, router: router)
        let providersProcess = GetProvidersProcess()
        
        providersProcess.delegate = interactor
        interactor.providersProcess = providersProcess
        
        searchController.presenter = presenter
        interactor.presenter = presenter
        
        let nav = UINavigationController(rootViewController: searchController)
        return nav
    }
    
    func navigateToMovieDetail(from: SearchView?, movie: Movie) {
        let detailModule = MovieDetailRouter.createMovieDetailModule(forMovie: movie)
        from?.navigationController?.pushViewController(detailModule, animated: false)
    }
}
