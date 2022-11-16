//
//  HomeRouter.swift
//  eMovie
//
//  Created by Leandro Berli on 01/11/2022.
//

import Foundation
import UIKit

protocol HomeRouterProtocol {
    static func createHomeModule() -> UIViewController
    func navigateMovieDetailScreen(from view: UIViewController, andMovie: Movie)
}

class HomeRouter: HomeRouterProtocol {
    
    class func createHomeModule() -> UIViewController {
        let homeController = HomeViewController()
        var providersProcess: GetProvidersProcessProtocol = GetProvidersProcess()
        var interactor: HomeInteractorProtocol = HomeInteractor(httpClient: HTTPClient(), providerProcess: providersProcess)
        providersProcess.delegate = interactor
        
        let router: HomeRouterProtocol = HomeRouter()
        let presenter = HomePresenter(view: homeController, interactor: interactor, router: router)
        homeController.presenter = presenter
        interactor.presenter = presenter
        
        let item = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        homeController.tabBarItem = item
        
        let nav = UINavigationController(rootViewController: homeController)
        return nav
    }
    
    func navigateMovieDetailScreen(from view: UIViewController, andMovie: Movie) {
        let detailModule = MovieDetailRouter.createMovieDetailModule(forMovie: andMovie)
        view.navigationController?.pushViewController(detailModule, animated: true)
    }
}
