//
//  ProfileRouter.swift
//  eMovie
//
//  Created by Leandro Berli on 05/11/2022.
//

import Foundation
import UIKit

protocol ProfileRouterProtocol {
    static func createProfileModule() -> UIViewController
    func navigateAfterLogoutAction(fromView: UIViewController?)
    func navigateToMovieDetail(fromView: UIViewController?, movie: Movie)
}

class ProfileRouter: ProfileRouterProtocol {
    static func createProfileModule() -> UIViewController {
        let viewController: ProfileViewController = ProfileViewController()
        var interactor: ProfileInteractorProtocol = ProfileInteractor()
        let router: ProfileRouterProtocol = ProfileRouter()
        let presenter = ProfilePresenter(view: viewController, interactor: interactor, router: router)
    
        viewController.presenter = presenter
        interactor.presenter = presenter
         
        let providersProcess = GetProvidersProcess()
        providersProcess.delegate = interactor
        interactor.providersProcess = providersProcess
        
        
        let item3 = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        viewController.tabBarItem = item3
        
        let nav = UINavigationController(rootViewController: viewController)
        
        return nav
    }
    
    func navigateAfterLogoutAction(fromView: UIViewController?) {
        let loginModule = LoginRouter.createLoginModule()
        fromView?.tabBarController?.viewControllers?.append(loginModule)
        fromView?.tabBarController?.viewControllers?.remove(at: 2)
    }
    
    func navigateToMovieDetail(fromView: UIViewController?, movie: Movie) {
        let detailModule = MovieDetailRouter.createMovieDetailModule(forMovie: movie)
        guard let detail = detailModule as? MovieDetailViewController else { return }
        detail.presenter?.favorite = true
        fromView?.navigationController?.pushViewController(detailModule, animated: true)
    }
    
}
